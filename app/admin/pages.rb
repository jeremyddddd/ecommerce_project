ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  form do |f|
    f.inputs "Page Details" do
      f.input :title
      f.input :slug, hint: "e.g., 'about', 'contact'"
      f.input :content, as: :text, input_html: { rows: 10 }
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content
    end
  end
end
