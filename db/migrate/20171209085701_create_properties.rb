class CreateProperties < ActiveRecord::Migration[5.1]
  def up
    create_table :properties do |t|
      t.column :building_name, :string, null: false
      t.column :address, :string, null: false

      t.timestamps null: false
    end
  end

  def down
    drop_table :properties
  end
end
