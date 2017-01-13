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
    product.find_price
  end

  def self.find_product(code)
    all.each do |product|
      return product if product.products_attributes['code'].to_sym == code
    end
  end

  def find_price
    products_attributes['price'].to_f
  end
end
