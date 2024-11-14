class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[ show update destroy members]
  before_action :set_user, only: %i[ add_member remove_member ]
  load_and_authorize_resource

  # GET /teams
  def index
    @teams = current_user.teams

    render json: TeamSerializer.new(@teams).serializable_hash
  end

  # GET /teams/1
  def show
    render json: TeamSerializer.new(@team).serializable_hash
  end

  # POST /teams
  def create
    @team = CreateTeamService.new(owner: current_user, params: team_params.merge(owner: current_user)).call

    if @team.save
      render json: TeamSerializer.new(@team).serializable_hash, status: :created, location: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params.merge(owner: current_user))
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy!
  end

  def add_member
    authorize! :create, Membership, current_user
    if @user
      @team.add_member(@user, params[:role])
      render json: TeamSerializer.new(@team).serializable_hash, status: :created
    else
      render json: {
        error: "Record not found",
      message: "We couldn't found a member with the email : #{params[:email]}" }, status: :not_found
    end
  end

  def remove_member
    authorize! :delete, Membership, current_user

    if @user
      @team.remove_member(@user)
      render json: TeamSerializer.new(@team).serializable_hash, status: :ok
    else
      render json: {
        error: "Record not found",
      message: "We couldn't found a member with the email : #{params[:email]}" }, status: :not_found
    end
  end

  def members
    memberships = @team.memberships.includes(:user)
    render json: MembershipSerializer.new(memberships).serializable_hash
  end

  private

  def set_user
    @user = User.find_by_email(params[:email])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :description)
  end
end
