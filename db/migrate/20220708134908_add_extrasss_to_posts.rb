class AddExtrasssToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :name, :string
    add_column :posts, :material, :string
    add_column :posts, :process, :text
  end
end
