class TeamSerializer
  include JSONAPI::Serializer
  attributes :name, :description

  attribute :members do |team|
    team.memberships.map do |membership|
      {
        user_id: membership.user.email,
        role: membership.role
      }
    end
  end
end
