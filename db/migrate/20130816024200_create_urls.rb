class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :shortened_extension
      t.integer :status, default: 301 

      t.timestamps
    end
   add_index :urls, :original_url
  end
end
