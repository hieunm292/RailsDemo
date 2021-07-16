class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :find_by_user, only: [:create]
  before_action :find_user_relationship, only: [:destroy]

  def create
    current_user.follow @user
    flash[:success] = t ".create_fololow_success"
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @relationship.followed
    flash[:success] = t ".destroy_fololow_success"
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private
  def find_by_user
    return if @user = User.find_by(id: params[:followed_id])

    flash[:warning] = t ".user_not_found"
    redirect_to root_path
  end

  def find_user_relationship
    @relationship = Relationship.find_by(id: params[:id])
    return if @relationship

    flash[:warning] = t ".user_relationship_not_found"
    redirect_to root_path
  end

end
