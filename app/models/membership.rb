class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :team
  validates :user, uniqueness: { scope: :team }
  enum role: {
    Member: 0,
    Admin: 1
  }

  def admin?
    role == "Admin"
  end

  # Make member an admin.
  #
  def make_admin
    update(role: "Admin")
  end
end
