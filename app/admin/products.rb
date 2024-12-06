ActiveAdmin.register Product do
  permit_params :product_name, :description, :price, :sale_price, :on_sale, :stock_quantity, :category_id, :image, :remove_image

  filter :created_at
  filter :on_sale
  filter :updated_at
  filter :category

  index do
    selectable_column
    id_column
    column :product_name
    column :price
    column :sale_price
    column :on_sale
    column :stock_quantity
    column "Category", :category, sortable: "category_id" do |product|
      product.category&.category_name
    end
    column "New?" do |product|
      product.created_at >= 3.days.ago ? "Yes" : "No"
    end
    column "Recently Updated?" do |product|
      product.updated_at >= 3.days.ago && product.created_at < product.updated_at ? "Yes" : "No"
    end
    actions
  end

  show do
    attributes_table do
      row :product_name
      row :description
      row :price
      row :sale_price
      row :on_sale
      row :stock_quantity
      row "Category" do |product|
        product.category&.category_name
      end
      row "New?" do |product|
        product.created_at >= 3.days.ago ? "Yes" : "No"
      end
      row "Recently Updated?" do |product|
        product.updated_at >= 3.days.ago && product.created_at < 3.days.ago ? "Yes" : "No"
      end
      row "Image" do |product|
        if product.image.attached?
          image_tag url_for(product.image), size: "200x200"
        else
          "No Image Available"
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :product_name
      f.input :description
      f.input :price
      f.input :sale_price, hint: "Optional: Add a sale price if the product is on sale"
      f.input :on_sale
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all.pluck(:category_name, :id)
      f.input :image, as: :file, hint: (f.object.image.attached? ? image_tag(url_for(f.object.image), size: "100x100") : "No image uploaded")
      if f.object.image.attached?
        f.input :remove_image, as: :boolean, label: "Remove current image"
      end
    end
    f.actions
  end

  controller do
    def update
      if params[:product][:remove_image] == "1"
        resource.image.purge
      end
      super
    end
  end
end
