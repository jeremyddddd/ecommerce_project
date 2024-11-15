ActiveAdmin.register Product do
  permit_params :product_name, :description, :price, :stock_quantity, :category_id, :image

  filter :created_at

  index do
    selectable_column
    id_column
    column :product_name
    column :price
    column :stock_quantity
    column "Category", :category, sortable: "category_id" do |product|
      product.category&.category_name
    end
    actions
  end

  show do
    attributes_table do
      row :product_name
      row :description
      row :price
      row :stock_quantity
      row "Category" do |product|
        product.category&.category_name
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :product_name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all.pluck(:category_name, :id)
      f.input :image, as: :file
    end
    f.actions
  end
end
