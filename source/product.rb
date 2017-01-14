# Products data initializing and retrieving, being downloaded from JSON file.
class Product
  attr_accessor :products_attributes

  @products = []

  def initialize(products_attributes)
    @products_attributes = products_attributes
  end

  def self.init(products)
    products.each do |products_attributes|
      @products << Product.new(products_attributes)
    end
  end

  def self.all
    @products
  end

  def self.get_product_price(code)
    product = find_product(code)
    product.nil? ? 0 : product.product_price
  end

  def self.find_product(code)
    all.each do |product|
      return product if product.products_attributes['code'].to_sym == code
    end
    nil
  end

  def product_price
    products_attributes['price']
  end
end
