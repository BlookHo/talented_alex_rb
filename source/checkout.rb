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
    # Нашел, не очень очевидно. Не думаю что в, по сути, сид файле стоит объявлять константу.
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
    items.each_with_object(Hash.new(0)) { |object, hash| hash[object] += 1 }
  end

  # почему total принимает параметр?
  def total#(price = 0)
    price = 0
    cart_content.each do |product, qty|
      price += prices[product] * qty
    end
    price.round(2)
  end

  def apply_rules(pricing_rules, item)
    pricing_rules.each do |rule|
      one_rule_apply(rule, item)
    end
  end

  def one_rule_apply(one_rule, item)
    rule = Rule.new(one_rule)
    if rule.satisfies_conditions?(cart_content, item)
      proceed_with_rule(rule)
    else
      # по хорошему надо все логи выводить только в случае если DEBUG=true из ENV https://github.com/bkeepers/dotenv
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
    cart_actions.each do |action|
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
    update_items(product_name, action_value)
  end

  # больно метод похож на тот из rule.rb. Возможно стоит сделать отдельный класс
  def action_eval(cart_value, action_name, action_value)
    instance_eval("#{cart_value}#{ACTIONS_METHODS[action_name]}#{action_value}")
  end

# Без пояснений не ясно, каким образом заполнение массива вызывает update у items?
  def update_items(product_name, action_value)
    [1..action_value].each { items << product_name }
  end

  def update_price(rule)
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
