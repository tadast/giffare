class AddHiddenToGifs < ActiveRecord::Migration
  def change
    add_column :gifs, :hidden, :boolean
  end
end
