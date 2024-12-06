require 'csv'

categories = [ "spatula", "lighter", "knives", "rice_cooker" ]
categories.each do |category_file|
  category_name = category_file.split('.').first.capitalize
  category = Category.create!(category_name: category_name)

  csv_path = Rails.root.join("db/seeds/#{category_file}.csv")
  CSV.foreach(csv_path, headers: true) do |row|
    Product.create!(
      product_name: row['product_name'],
      description: row['description'],
      price: row['price'].gsub(/[^\d\.]/, '').to_f,
      stock_quantity: rand(10..100),
      category: category
    )
  end
end

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Page.create(title: "About", content: "This is the about page content.", slug: "about")
Page.create(title: "Contact", content: "This is the contact page content.", slug: "contact")

Province.create([
  { name: "Manitoba", gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: "Ontario", gst: 5.0, pst: 0.0, hst: 13.0 },
  { name: "Quebec", gst: 5.0, pst: 9.975, hst: 0.0 },
  { name: "British Columbia", gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: "Alberta", gst: 5.0, pst: 0.0, hst: 0.0 }
])

Status.create!([
  { status: "Pending" },
  { status: "Processing" },
  { status: "Completed" }
])
