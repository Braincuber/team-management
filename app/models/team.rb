class Team < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  def add_member(member, role)
    Membership.create!(
      team_id: id,
      user_id: member.id,
      role: role,
    )
  end

  def remove_member(member)
    membership = memberships.find_by(user_id: member.id)
    unless membership.present?
      raise ActiveRecord::RecordNotFound, "Couldn't find Membership with the member : #{member.email}"
    end

    if membership.Admin? && memberships.where(role: "Admin").count == 1 # && memberships.count > 1
      raise ActiveRecord::RecordNotDestroyed,
"Cannot remove the only admin from a team unless they are also the only member"
    else
      membership.destroy
    end

    reassign_owner if owner === member

    membership.destroy
  end

  def reassign_owner
    reload

    # only if there's another member in addition to the owner
    # the owners membership has already been removed
    return unless members.present?

    # aim to choose an admin role if possible
    membership = memberships.order(:role).first

    # make a new owner
    set_owner(membership.user)
  end

  # set a new owner of this team
  def set_owner(member)
    update(owner_id: member.id)
  end

  def admins
    User.where(id: memberships.where(role: "Admin").select(:user_id))
  end

  def set_owner(member)
    update(owner_id: member.id)
  end
end
