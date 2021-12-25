class AuthenticatedUserController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: UserBlueprint.render(current_user), status: :ok
  end

  def update
    param! :first_name, String
    param! :last_name, String
    param! :height, Integer, min: 1
    param! :sex, String, in: %w[female male]
    param! :condition, Hash do |condition|
      condition.param! :weight, Float, min: 0
    end

    current_user.update({
      first_name: user_params[:first_name],
      height: user_params[:height],
      last_name: user_params[:last_name],
      sex: user_params[:sex],
      condition_attributes: user_params[:condition].to_h,
    }.compact_blank)

    head :ok
  end

  private

  def user_params
    params.require(:authenticated_user).permit(
      :first_name,
      :height,
      :last_name,
      :sex,
      condition: [:weight]
    )
  end
end
