ActiveAdmin.register OrderDetail do
  permit_params :order_id, :product_id, :quantity, :order_price

  filter :order_id
  filter :product_id
  filter :quantity
  filter :order_price
  filter :created_at

  index do
    selectable_column
    id_column
    column :order_id
    column "Product" do |order_detail|
      Product.find(order_detail.product_id).product_name
    end
    column :quantity
    column :order_price do |order_detail|
      number_to_currency(order_detail.order_price)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :order_id
      row "Product" do |order_detail|
        Product.find(order_detail.product_id).product_name
      end
      row :quantity
      row :order_price do |order_detail|
        number_to_currency(order_detail.order_price)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :order_id, as: :select, collection: Order.all.pluck(:id)
      f.input :product_id, as: :select, collection: Product.all.pluck(:product_name, :id)
      f.input :quantity
      f.input :order_price
    end
    f.actions
  end
end
