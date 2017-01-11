class Product
  attr_accessor :price, :code, :name

  @products = []

  def self.init(products)
    products.each do |product_attrs|
      @products << Product.new(product_attrs)
    end
  end

  def self.all
    @products
  end

  def initialize(attributes)
    @price = attributes[:price]
    @code = attributes[:code]
    @name = attributes[:name]
  end
end
