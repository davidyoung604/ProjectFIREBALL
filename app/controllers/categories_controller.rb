class CategoriesController < ApplicationController
  include CategoriesHelper
  before_action :user_auth
  before_action :admin_auth, only: [:edit, :destroy] # add new and create?
  after_action :collect_unsorted_extensions, only: [:create, :destroy, :update]

  def index
    @cats = Category.all
  end

  def new
    @cat = Category.new
  end

  def edit
    @cat = Category.find(params[:id])
  end

  def show
    @cat = Category.find(params[:id])
    @exts = @cat.extensions.order(:name)
    @files_by_ext = files_by_ext
    @n_files_in_cat = @files_by_ext.values.map(&:count).reduce(&:+) || 0
  end

  def destroy
    cat = Category.find(params[:id])
    # TODO: need a better way of identifying this special category
    if cat.name == 'Unsorted'
      flash[:info] = 'This is the collector category and should not be deleted.'
      redirect_to cat
    else
      cat.destroy
      redirect_to categories_path
    end
  end

  def create
    @cat = Category.new(category_params)
    if @cat.save
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def update
    @cat = Category.find(params[:id])
    if @cat.update_attributes(category_params)
      redirect_to @cat
    else
      render 'edit'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :csv_extensions)
  end

  def files_by_ext
    cat_files = {}
    @exts.each { |ext| cat_files[ext.name] = visible_files(ext.user_files) }
    cat_files
  end
end
