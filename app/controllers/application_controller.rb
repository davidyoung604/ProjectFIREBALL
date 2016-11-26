class ApplicationController < ActionController::Base
  include SessionsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def admin_auth
    redirect_to root_path unless logged_in? && @current_user.admin
  end

  def user_auth
    redirect_to login_path unless logged_in?
  end

  def visible_files(file_list)
    file_list.select do |f|
      f.public || f.user.id == @current_user.id
    end
  end

  def update_and_touch(obj, params)
    if obj.update_attributes(params)
      obj.touch # update the updated_at field
      obj.save
      redirect_to obj
    else
      render 'edit'
    end
  end
end
