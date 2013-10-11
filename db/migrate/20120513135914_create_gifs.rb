class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.string :url
      t.string :title
      t.datetime :published_at
      t.boolean :nsfw, default: false

      t.timestamps
    end
    add_index :gifs, :url, unique: true
  end
end
