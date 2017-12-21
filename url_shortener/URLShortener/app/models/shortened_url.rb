require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :short_url, uniqueness: true, presence: true
  validates :user_id, :long_url, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :users

  has_many :tag_topics,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :TagTopic

  def self.random_code
    str = SecureRandom.urlsafe_base64(12)
    while ShortenedUrl.exists?(:short_url => str)
      str = SecureRandom.urlsafe_base64(12)
    end
    str
  end

  def self.create_shortened_url(user, long_url)
    shortened_url = ShortenedUrl.new(
      :user_id => user.id,
      :long_url => long_url,
      :short_url => ShortenedUrl.random_code
    )
    shortened_url.save!
  end

  def num_clicks
    visits.length
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits.select(:user_id).distinct.where("visits.created_at > ?", 10.minutes.ago).count
  end
end
