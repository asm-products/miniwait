class AddPasswordFields < ActiveRecord::Migration
  def change
     add_column :people, :password_salt, :string
     add_column :people, :password_reset_token, :string
  end
end
