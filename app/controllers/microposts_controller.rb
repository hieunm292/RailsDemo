class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    micropost_handle
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".micropost_delete_success"
    else
      flash[:danger] = t".micropost_delete_fail"
    end
    redirect_to request.referer || root_url
  end

  def micropost_handle
    if @micropost.save
      flash[:success] = t ".micropost_create_success"
    else
      flash[:danger] = t ".create_micropost_failed"
      @feed_items = Kaminari.paginate_array(current_user.feed)
                            .page(params[:page])
                            .per(Settings.user.micropost_per_page)
      redirect_to root_path
    end
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:warning] = t ".invalid_user"
    redirect_to request.referer || root_url
  end
end
