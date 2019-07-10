class AddUuidToShortLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :short_links, :uuid, :string
    add_index :short_links, :uuid
  end
end
