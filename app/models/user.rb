class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,:confirmable, :lockable, :timeoutable, :trackable

  belongs_to :role
  has_many :leave_requests, dependent: :destroy
  has_many :approved_leave_requests, class_name: "LeaveRequest", foreign_key: :approved_by_id, dependent: :nullify

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_present?
  validate :password_must_contain_special_characters
  
  private 
  def password_present?
    password.present?
  end

  def password_must_contain_special_characters
    return if password.blank?

    unless password.match?(/[^A-Za-z0-9]/)
      errors.add(:password, "must contain at least one specail character")
    end
  end
end
