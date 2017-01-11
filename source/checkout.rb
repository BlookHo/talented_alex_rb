class Checkout
  attr_reader :cart, :prices, :pricing_rules, :cart_content
  attr_writer :cart_content

  # todo:
  # take away cart and replace it with cart_content everywhere
  # use Product class - load products from json file of products data

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @cart = []
    @prices = {}
    @cart_content = {}
  end

  def scan(product_code)
    add_product_to_cart(product_code)
    try_rules(pricing_rules, product_code)
    p pricing_rules
    p "Current Total price = #{total}"
  end

  #  reduce
  def total
    price = 0
    cart_content.each do |product, qty|
      price += prices[product] * qty
    end
    price.round(2)
  end

  private

  def add_product_to_cart(product_code)
    cart << product_code
    prices.merge!(product_code => PRICE_LIST[product_code])
  end

  def analyse_cart
    cart.each_with_object(Hash.new(0)) { |object, hash| hash[object] += 1 }
  end

  def try_rules(pricing_rules, product_code)
    self.cart_content = analyse_cart  # change
    pricing_rules.each do |rule|
      try_rule(rule, product_code)
    end
  end

  def try_rule(one_rule, product_code)
    rule = Rule.new(one_rule)
    if rule.satisfies_conditions?(cart_content, product_code)
      execute_rule(rule)
    else
      # по хорошему надо все логи выводить только в случае если DEBUG=true из ENV https://github.com/bkeepers/dotenv
      puts "\nskip the rule: #{rule.title} \n\n"
    end
  end

  def execute_rule(rule)
    update_cart_content(rule)
    update_cart_prices(rule)
  end

  def update_cart_content(rule)
    rule.cart_actions.each do |action|
      # этот класс больно много знает о внутреннем устройстве Rule-ов
      one_action(action)
    end
  end

  def one_action(action)
    product_name = action['product_name'].to_sym
    action_name = action['action'].to_sym
    action_value = action['qty'].to_i
    cart_content[product_name] = action_eval(
      cart_content[product_name], action_name, action_value
    )
    update_cart(product_name, action_value)
  end

  # больно метод похож на тот из rule.rb. Возможно стоит сделать отдельный класс
  def action_eval(cart_value, action_name, action_value)
    instance_eval("#{cart_value}#{ACTIONS_METHODS[action_name]}#{action_value}")
  end

# Без пояснений не ясно, каким образом заполнение массива вызывает update у cart?
  def update_cart(product_name, action_value)
    [1..action_value].each { cart << product_name }
  end

  def update_cart_prices(rule)
    rule.product_pricing.each { |one_pricing| pricing(one_pricing) }
  end

  def pricing(pricing)
    product_name = pricing['product_name'].to_sym
    action_name = pricing['action'].to_sym
    pricing_value = pricing['qty'].to_f
    prices[product_name] = pricing_eval(
      PRICE_LIST[product_name], action_name, pricing_value
    )
  end

  # Тоже похожий
  def pricing_eval(product_price, action_name, pricing_value)
    instance_eval("#{product_price}#{PRICING_METHODS[action_name]}#{pricing_value}")
  end
end
