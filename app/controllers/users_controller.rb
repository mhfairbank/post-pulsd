class UsersController < ApplicationController
	def index
		@user = User.new
	end

	def create
		User.create(user_params)
	end

	private
    def user_params
      params.require(:user).permit(:email_address)
    end
end