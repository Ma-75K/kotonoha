class SorceryCore < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :crypted_password, :string unless column_exists?(:users, :crypted_password)
    add_column :users, :salt, :string unless column_exists?(:users, :salt)
  end
end
