class Rule
  attr_reader :title, :conditions, :cart_actions, :pricing_actions

  def initialize(rule)
    @title = rule['title']
    @conditions = rule['conditions']
    @cart_actions = rule['cart_actions']
    @pricing_actions = rule['pricing_actions']
  end

  def satisfies_conditions?(cart_content, product_code)
    conditions.all? do |condition|
      check_rule_to_execute?(
        cart_content[condition['product_code'].to_sym],
        condition['comparison'].to_sym,
        condition['qty']
      ) if product_code == condition['product_code'].to_sym
    end
  end

  def check_rule_to_execute?(product_code, compare_method_name, condition_value)
    instance_eval("#{product_code}#{COMPARE_METHODS[compare_method_name]}#{condition_value}")
  end
end
