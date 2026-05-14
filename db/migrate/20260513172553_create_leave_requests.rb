class CreateLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :leave_type, null: false, foreign_key: true

      t.date :application_date, null: false
      t.date :from_date, null: false
      t.date :to_date, null: false

      t.decimal :total_days, precision: 5, scale: 2, null: false

      t.boolean :is_half_day, null: false, default: false

      t.text :reason, null: false
      t.text :comment

      t.references :approved_by, foreign_key: { to_table: :users }

      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
