ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :password, :address, :phone_number
end
