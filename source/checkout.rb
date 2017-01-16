require './source/rules_applier'

# Main class of API entry points: scan, total (according to task)
class Checkout
  attr_reader :cart_content, :prices, :pricing_rules
  attr_writer :cart_content, :prices

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @prices = {}
    @cart_content = {}
  end

  def scan(product_code)
    add_product_to_cart(product_code)
    update_cart(try_rules(product_code))
    puts "\nProduct #{product_code} - scanned;"
  end

  def total
    cart_content.inject(0) { |price, (product, qty)| price += prices[product] * qty }
  end

  def add_product_to_cart(product_code)
    cart_content.key?(product_code) ? cart_content[product_code] += 1 : cart_content[product_code] = 1
    add_price_to_cart(product_code)
  end

  def add_price_to_cart(product_code)
    product_price = Product.get_product_price(product_code)
    puts "Unknown product #{product_code}. Price to be determined." if product_price.zero?
    prices[product_code] = product_price
  end

  private

  def try_rules(product_code)
    rules_applier = RulesApplier.new(self, product_code)
    rules_applier.execute
  end

  def update_cart(new_cart)
    self.cart_content = new_cart.cart_content
    self.prices = new_cart.prices
  end
end
