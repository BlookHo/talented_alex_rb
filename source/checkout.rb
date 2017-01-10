class Checkout
  attr_reader :items, :prices, :pricing_rules, :cart_content

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @items = []
    @prices = {}
    @cart_content = {}
  end

  def scan(item)
    add_item(item)
    set_price(item, PRICE_LIST[item])
    @cart_content = analyse_cart
    apply_rules(pricing_rules, item)
    p "Current Total price = #{total}"
  end

  def add_item(item)
    items << item
  end

  def multiply_item(item, qty, i = 0)
    while i == qty
      items << item
      i += 1
    end
  end

  def set_price(item, price)
    prices.merge!(item => price)
  end

  def analyse_cart
    items.each_with_object(Hash.new(0)) { |o, h| h[o] += 1 }
  end

  def total(price = 0)
    cart_content.each do |product, qty|
      price += prices[product] * qty
    end
    price.round(2)
  end

  def apply_rules(pricing_rules, item)
    pricing_rules.each do |one_rule|
      one_rule_apply(one_rule, item)
    end
  end

  def one_rule_apply(one_rule, item)
    rule = Rule.new(one_rule)
    if rule.check_conditions?(cart_content, item)
      proceed_with_rule(rule)
    else
      puts "\nskip the rule: #{rule.title} \n\n"
    end
  end

  private

  def proceed_with_rule(rule)
    update_content(rule)
    update_price(rule)
  end

  def update_content(rule)
    cart_actions = rule.cart_actions
    cart_actions.each do |one_action|
      one_action(one_action)
    end
  end

  def one_action(one_action)
    product_name = one_action['product_name'].to_sym
    action_name = one_action['action'].to_sym
    action_value = one_action['qty'].to_i
    cart_content[product_name] = action_eval(
      cart_content[product_name], action_name, action_value
    )
    update_items(product_name, action_value)
  end

  def action_eval(cart_value, action_name, action_value)
    instance_eval("#{cart_value}#{ACTIONS_METHODS[action_name]}#{action_value}")
  end

  def update_items(product_name, action_value)
    [1..action_value].each { items << product_name }
  end

  def update_price(rule)
    rule.product_pricing.each { |one_pricing| pricing(one_pricing) }
  end

  def pricing(one_pricing)
    product_name = one_pricing['product_name'].to_sym
    action_name = one_pricing['action'].to_sym
    pricing_value = one_pricing['qty'].to_f
    prices[product_name] = pricing_eval(
      PRICE_LIST[product_name], action_name, pricing_value
    )
  end

  def pricing_eval(product_price, action_name, pricing_value)
    instance_eval("#{product_price}#{PRICING_METHODS[action_name]}#{pricing_value}")
  end
end
