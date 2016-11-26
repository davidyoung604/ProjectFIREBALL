module CategoriesHelper
  def collect_unsorted_extensions
    cat = Category.where(name: 'Unsorted').first
    cat.extensions << Extension.where(category_id: nil)
  end
end
