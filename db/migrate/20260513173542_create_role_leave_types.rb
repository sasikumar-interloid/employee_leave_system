class CreateRoleLeaveTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :role_leave_types do |t|
     t.references :role, null: false, foreign_key: true

      t.references :leave_type, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :role_leave_types, [:role_id, :leave_type_id], unique: true, name: "index_role_leave_types_on_role_and_leave_type"
  end
end
