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
      price: row['price'],
      stock_quantity: rand(10..100),
      category: category
    )
  end
end

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
