class Rule
  attr_reader :title, :conditions, :cart_actions, :pricing_actions

  def initialize(rule)
    @title = rule['title']
    @conditions = rule['conditions']
    @cart_actions = rule['cart_actions']
    @pricing_actions = rule['pricing_actions']
  end

  def satisfies_conditions?(cart_content, item)
    conditions.all? do |condition|
      should_be_applied?(condition, cart_content) if item == condition['product_code'].to_sym
    end
  end

  def should_be_applied?(condition, cart_content)
    compare_method_name = condition['comparison'].to_sym
    if COMPARE_METHODS.keys.include?(compare_method_name)
      return condition_eval?(
        cart_content[condition['product_code'].to_sym], compare_method_name, condition['qty'].to_i
      )
    else
      # почему не вызов validation error/аналог?
      puts "\nValidate your rule!"
    end
    false
  end

  def condition_eval?(object, compare_method_name, condition_value)
    instance_eval("#{object}#{COMPARE_METHODS[compare_method_name]}#{condition_value}")
  end
end
