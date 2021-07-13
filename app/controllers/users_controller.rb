class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :load_user, only: [:show, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(Settings.user.per_page)
  end

  def show
    @microposts = Kaminari.paginate_array(@user.microposts)
                          .page(params[:page])
                          .per(Settings.user.micropost_per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".notify_email_active_account"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_fail"
    end
    redirect_to users_url
  end

  def following
    @title = t ".title_following"
    @users = Kaminari.paginate_array(@user.following)
                     .page(params[:page])
                     .per(Settings.user.folow_per_page)
    render :show_follow
  end

  def followers
    @title = t ".title_followers"
    @users = Kaminari.paginate_array(@user.followers)
                     .page(params[:page])
                     .per(Settings.user.folow_per_page)
    render :show_follow
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t ".user_not_found"
    redirect_to about_path
  end

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    redirect_to root_url unless @user == current_user
  end
end
