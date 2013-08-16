class ChangeColumnNameOnUrls < ActiveRecord::Migration
  def change
  	rename_column :urls, :shortened_url, :shortened_extension
  end
end
