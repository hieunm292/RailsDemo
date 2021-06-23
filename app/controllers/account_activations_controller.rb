class AccountActivationsController < ApplicationController
	def edit
		user = User.find_by email: params[:email]
		if user && !user.activated? && user.authenticated?(:activation, params[:id])

			user.activate

			Log_in user
			flash[:success]="Account activation success !"
			redirect_to user

		else
			flash[:error]="Invalid activation !"
			redirect_to root_url
		end
	end

end
