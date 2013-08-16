class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :shortened_url
      t.integer :status, default: 301 

      t.timestamps
    end
   add_index :urls, :original_url
  end
end
