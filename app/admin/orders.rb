ActiveAdmin.register Order do
  permit_params :user_id, :order_date, :status_id, :payment_status, :stripe_payment_id

  # Filters
  filter :user
  filter :order_date
  filter :status, as: :select, collection: -> { Status.all.pluck(:status, :id) }
  filter :payment_status
  filter :stripe_payment_id
  filter :created_at
  filter :updated_at

  # Index Page
  index do
    selectable_column
    id_column
    column :user
    column :order_date
    column :status do |order|
      order.status&.status
    end
    column :payment_status
    column :stripe_payment_id
    column :created_at
    column :updated_at
    actions
  end

  # Show Page
  show do
    attributes_table do
      row :id
      row :user
      row :order_date
      row :status do |order|
        order.status&.status
      end
      row :payment_status
      row :stripe_payment_id
      row :created_at
      row :updated_at
    end

    panel "Order Details" do
      table_for order.order_details do
        column :product
        column :quantity
        column :order_price do |detail|
          number_to_currency(detail.order_price)
        end
      end
    end
  end

  # Form
  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.pluck(:email, :id)
      f.input :order_date, as: :datepicker
      f.input :status_id, as: :select, collection: Status.all.pluck(:status, :id)
      f.input :payment_status
    end
    f.actions
  end
end
