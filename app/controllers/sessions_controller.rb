class SessionsController < ApplicationController
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
      render text: "Logged in as #{@user.username}"
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
