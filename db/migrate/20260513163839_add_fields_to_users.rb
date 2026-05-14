class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :role, null: false, foreign_key: true

    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string

    add_column :users, :mobile_number, :string, null: false
    add_index :users, :mobile_number, unique: true

    add_column :users, :gender, :string, null: false
    add_column :users, :address, :text, null: false
    add_column :users, :dob, :date
    add_column :users, :education, :string
    add_column :users, :profile_image, :string

    add_column :users, :status, :string, null: false, default: "Active"
  end
end
