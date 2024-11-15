ActiveAdmin.register Order do
  permit_params :user_id, :order_date, :status_id
end
