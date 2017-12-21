class TagTopic < ApplicationRecord
  validates :topic, :shortened_url_id, presence: true

  belongs_to :url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :ShortenedUrl
end
