# Methods: start check, whether rule can be applied; start rule execution; update cart data after rule execution
class RulesApplier
  attr_reader :checkout, :product_code

  def initialize(checkout, product_code)
    @checkout = checkout
    @product_code = product_code
  end

  def execute
    checkout.pricing_rules.each do |rule|
      try_rule(rule, product_code)
    end
    checkout
  end

  def try_rule(rule_attr, product_code)
    rule = Rule.new(rule_attr)
    if rule.satisfies_conditions?(checkout.cart_content, product_code)
      execute_rule(rule, product_code)
      puts "\nexecute the rule: #{rule.title} \n"
    else
      puts "\nskip the rule: #{rule.title} \n"
    end
  end

  def execute_rule(rule, product_code)
    update_cart_content(rule.cart_actions)
    update_cart_prices(rule.pricing_actions, product_code)
  end

  def update_cart_content(cart_actions)
    cart_actions.each do |action|
      product_in_action = action['product_code'].to_sym
      checkout.cart_content[product_in_action] = updated_product(action)
    end
  end

  def updated_product(action)
    fulfill_action(action, product_in_cart(action), ACTIONS_METHODS)
  end

  def product_in_cart(action)
    checkout.cart_content[action['product_code'].to_sym]
  end

  def update_cart_prices(pricing_actions, product_code)
    pricing_actions.each do |action|
      checkout.prices[action['product_code'].to_sym] = updated_price(action, product_code)
    end
  end

  def updated_price(action, product_code)
    fulfill_action(action, Product.get_product_price(product_code), PRICING_METHODS)
  end

  def fulfill_action(action, action_object, action_methods)
    action_name = action['action'].to_sym
    action_value = action['qty']
    instance_eval("#{action_object} #{action_methods[action_name]} #{action_value}")
  end
end
