class ChangePrimaryInServices < ActiveRecord::Migration
  def up
	  change_column :services, :is_primary, 'boolean USING CAST(is_primary AS boolean)'
  end
  def down
	  change_column :services, :is_primary, :string
  end
end
