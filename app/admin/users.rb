ActiveAdmin.register User do
  # Permit parameters for create/update actions
  permit_params :first_name, :last_name, :email, :phone_number, :address, :province_id, :password, :password_confirmation

  filter :email
  filter :first_name
  filter :last_name
  filter :phone_number
  filter :address
  filter :province, as: :select, collection: -> { Province.all.pluck(:name, :id) }

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :phone_number
    column :address
    column "Province", :province, sortable: :province_id do |user|
      user.province&.name
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :phone_number
      row :address
      row "Province" do |user|
        user.province&.name
      end
      row :reset_password_sent_at
      row :remember_created_at
      row :reset_password_token
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone_number
      f.input :address
      f.input :province, as: :select, collection: Province.all.pluck(:name, :id)
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
