class ApplicationController < ActionController::Base
  include SessionsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def admin_auth
    redirect_to root_path unless logged_in? && current_user.admin
  end

  def user_auth
    redirect_to login_path unless logged_in?
  end

  def visible_files(file_list)
    return file_list if current_user.admin
    file_list.where(public: true).or(file_list.where(user: current_user))
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
