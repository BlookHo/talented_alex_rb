class RulesApplier
  attr_reader :checkout, :product_code

  def initialize(checkout, product_code)
    @checkout = checkout
    @product_code = product_code
  end

  def execute
    self.checkout.pricing_rules.each do |rule|
      try_rule(rule, product_code)
    end
    self.checkout
  end

  def try_rule(one_rule, product_code)
    rule = Rule.new(one_rule)
    if rule.satisfies_conditions?(self.checkout.cart_content, product_code)
      execute_rule(rule, product_code)
      puts "\nexecute the rule: #{rule.title} \n"
    else
      # по хорошему надо все логи выводить только в случае если DEBUG=true из ENV https://github.com/bkeepers/dotenv
      puts "\nskip the rule: #{rule.title} \n"
    end
  end

  def execute_rule(rule, product_code)
    update_cart_content(rule.cart_actions)
    update_cart_prices(rule.pricing_actions, product_code)
  end

  def update_cart_content(cart_actions)
    cart_actions.each do |action|
      self.checkout.cart_content[action['product_code'].to_sym] =
        fulfill_action(action, self.checkout.cart_content[action['product_code'].to_sym], ACTIONS_METHODS)
    end
  end

  def update_cart_prices(pricing_actions, product_code1)
    pricing_actions.each do |action|
      self.checkout.prices[action['product_code'].to_sym] =
        fulfill_action(action, Product.get_product_price(product_code1), PRICING_METHODS)
    end
  end

  def fulfill_action(action, action_object, action_methods)
    action_name = action['action'].to_sym
    value = action['qty'].to_f
    instance_eval("#{action_object} #{action_methods[action_name]} #{value}")
  end

end
