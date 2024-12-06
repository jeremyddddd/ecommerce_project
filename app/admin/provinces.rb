ActiveAdmin.register Province do
  permit_params :name, :gst, :pst, :hst

  filter :name
  filter :gst
  filter :pst
  filter :hst

  index do
    selectable_column
    id_column
    column :name
    column :gst
    column :pst
    column :hst
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :gst
      row :pst
      row :hst
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end
end
