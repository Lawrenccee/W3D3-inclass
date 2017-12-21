class CreateTagTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_topics do |t|
      t.integer :shortened_url_id, null: false
      t.string :topic, null: false

      t.timestamps
    end

    add_index :tag_topics, :topic
    add_index :tag_topics, :shortened_url_id
  end
end
