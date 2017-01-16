require 'json'
require './source/product'
require './source/rule'

# Downloads rules and products from JSON files (without database storage at the moment)
class Parser
  def self.load_rules(filepath)
    parse(filepath, 'rules')
  end

  def self.load_products(filepath)
    products_attributes = parse(filepath, 'products')
    Product.init(products_attributes)
  end

  def self.parse(filepath, attr)
    JSON.parse(File.read(filepath))[attr]
  end
end
