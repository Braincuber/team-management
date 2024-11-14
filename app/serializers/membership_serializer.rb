class MembershipSerializer
  include JSONAPI::Serializer
  attribute :user do |membership|
    {
      email: membership.user.email,
      role: membership.role
    }
  end
end
