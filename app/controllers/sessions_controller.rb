class SessionsController < ApplicationController
  def new
  end

  def create
    return if valid_login
    flash.now[:danger] = 'Invalid username/password combination'
    render 'new'
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private

  def valid_login
    user = User.where(name: params[:session][:name]).first
    return nil unless user && user.authenticate(params[:session][:password])

    log_in user
    redirect_to root_path
    user
  end
end
