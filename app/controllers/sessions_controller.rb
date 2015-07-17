class SessionsController < ApplicationController
  before_action :redirect_to_index_if_logged_in, except: [:destroy]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params[:username],
                                     user_params[:password]
                                     )
    if @user
      log_in_user!(@user)
      flash[:messages] = ["Logged in as #{@user.username}"]
      redirect_to subs_url
    else
      flash.now[:errros] = ["Invalid credentials"]
      render :new
    end
  end

  def destroy
    log_out_user!
    redirect_to new_session_url
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
