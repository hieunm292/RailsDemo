class PasswordResetsController < ApplicationController
  before_action :load_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = t ".email_send_success"
      redirect_to root_url
    else
      flash[:danger] = t ".email_send_fail"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".error_password_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t ".reset_password_success"
      redirect_to login_path
    else
      render :edit
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.activate && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".reset_password_error"
    redirect_to root_path
  end

  def check_expiration
    return unless password_reset_expired?

    flash[:danger] = t ".password_expired"
    redirect_to
  end
end
