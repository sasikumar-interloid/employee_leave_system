class CreateLeaveBalances < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_balances do |t|
     t.references :user, null: false, foreign_key: true

      t.references :leave_type, null: false, foreign_key: true

      t.integer :total_leaves, null: false

      t.integer :used_leaves, null: false, default: 0

      t.integer :year, null: false

      t.integer :carried_forward, null: false, default: 0

      t.timestamps
    end

    add_index :leave_balances, [:user_id, :leave_type_id, :year], unique: true, name: "index_leave_balances_on_user_leave_type_year"
  end
end
