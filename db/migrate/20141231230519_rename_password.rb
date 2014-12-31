class RenamePassword < ActiveRecord::Migration
  def change
     rename_column :people, :password, :password_hash
  end
end
