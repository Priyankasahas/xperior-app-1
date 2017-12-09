class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.column :first_name, :string, null: false
      t.column :last_name, :string, null: false
      t.column :email, :string, null: false
      t.column :password_digest, :string, null: false

      t.timestamps null: false
    end
  end

  def down
    drop_table :users
  end
end
