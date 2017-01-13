require 'json'
require './source/product'

class Parser

  def self.load_rules(filepath)
    JSON.parse(File.read(filepath))['rules']
  end

  def self.load_products(filepath)
    products_attributes = JSON.parse(File.read(filepath))['products']
    Product.init(products_attributes)
  end
end
