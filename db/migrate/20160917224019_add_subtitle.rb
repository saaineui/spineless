class AddSubtitle < ActiveRecord::Migration
  def change
	add_column :books, :subtitle, :string
  end
end
