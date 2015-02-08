class AddLocNameToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :loc_name, :string
  end
end
