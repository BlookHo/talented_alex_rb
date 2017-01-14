require './source/rules_applier'

# Main class of API entry points: scan, total (according to task)
class Checkout
  attr_reader :cart_content, :prices, :pricing_rules
  attr_writer :cart_content, :prices

  # TODO: RSpec

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @prices = {}
    @cart_content = {}
  end

  def scan(product_code)
    add_product_to_cart(product_code)
    update_cart(try_rules(product_code))
    puts "\nCurrent Total price = #{total};"
  end

  def total
    cart_content.inject(0) { |price, (product, qty)| price += prices[product] * qty }
  end

  private

  def add_product_to_cart(product_code)
    cart_content.key?(product_code) ? cart_content[product_code] += 1 : cart_content[product_code] = 1
    prices[product_code] = Product.get_product_price(product_code)
  end

  def try_rules(product_code)
    rules_applier = RulesApplier.new(self, product_code)
    rules_applier.execute
  end

  def update_cart(new_cart)
    self.cart_content = new_cart.cart_content
    self.prices = new_cart.prices
  end
end
