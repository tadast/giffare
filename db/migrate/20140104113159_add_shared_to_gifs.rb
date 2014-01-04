class AddSharedToGifs < ActiveRecord::Migration
  def change
    add_column :gifs, :shared, :boolean, default: false
  end
end
