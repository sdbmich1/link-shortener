class AddShortUrlToShortLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :short_links, :short_url, :string
    add_index :short_links, :short_url
    add_column :short_links, :expired, :boolean
    add_index :short_links, :original_url
  end
end
