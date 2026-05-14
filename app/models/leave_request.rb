class LeaveRequest < ApplicationRecord
  belongs_to :users
  belongs_to :leave_type

  belongs_to :approved_by, class_name: "User", optional: true
end
