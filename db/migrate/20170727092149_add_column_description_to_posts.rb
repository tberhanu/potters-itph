class AddColumnDescriptionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :description, :text
  end
end
