require 'creates_users'
require 'updates_users'

module V1
  class UsersController < PrivateController
    def index
      render json: User.all
    end

    def show
      user = User.user_by_id(params[:id])

      if user
        render json: user
      else
        head :not_found
      end
    end

    def create
      create = CreatesUsers.create!(create_params)

      if create.success?
        render json: create.user, status: :created
      else
        render json: create.errors, status: :bad_request
      end
    end

    def update
      update = UpdatesUsers.update!(params[:id], update_params)

      if update.success?
        render json: update.user
      else
        render json: update.errors, status: :bad_request
      end
    end

    def destroy
      s = User.find_by(id: params[:id])
      if s.present?
        s.destroy
        render json: { success: true }
      else
        render json: { success: false, error: "User not found with #{params[:id]}" }, status: :not_found
      end
    end

    private

    def create_params
      params.require(:user).permit(
        :first_name, :last_name, :email, :password, :password_confirmation
      )
    end

    def update_params
      params.require(:user).permit(
        :first_name, :last_name, :email
      )
    end
  end
end
