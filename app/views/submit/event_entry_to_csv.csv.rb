
require 'csv'

CSV.generate do |csv|
  csv_column_names = ["製品名","製品説明","価格"]
  csv << csv_column_names
  @products.each do |product|
    csv_column_values = [
      product.name,
      product.description,
      product.price,
    ]
    csv << csv_column_values
  end
end
