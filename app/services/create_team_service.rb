  # frozen_string_literal: true

  class CreateTeamService
    def initialize(owner:, params: {})
      @owner = owner
      @name = params[:name] || owner.email
      @description = params[:description]
    end

    def call
      team = Team.create(
        name: @name,
        description: @description,
        owner_id: @owner.id
      ).tap do |team|
        team.add_member(@owner, "Admin")
      end
    end
  end
