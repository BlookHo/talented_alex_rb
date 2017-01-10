require 'json'

class Rule
  attr_reader :title, :conditions, :cart_actions, :product_pricing

  def initialize(rule)
    @title = rule['title']
    @conditions = rule['conditions']
    @cart_actions = rule['cart_actions']
    @product_pricing = rule['product_pricing']
  end

  def self.load_rules(filepath)
    JSON.parse(File.read(filepath))['rules']
  end

  def check_conditions?(cart_content, item)
    to_apply = false
    conditions.each do |one_condition|
      to_apply = apply?(one_condition, cart_content, item)
      return false unless to_apply
    end
    to_apply
  end

  def apply?(condition, cart_content, item)
    to_apply(condition, cart_content) if item == condition['product_name'].to_sym
  end

  def to_apply(condition, cart_content)
    to_apply = false
    method_name = condition['comparison'].to_sym
    if COMPARE_METHODS.keys.include?(method_name)
      to_apply = condition_eval?(
        method_name, cart_content[condition['product_name'].to_sym], condition['qty'].to_i
      )
    else
      puts 'Validate your rule!'
    end
    to_apply
  end

  def condition_eval?(method_name, box_value, condition_value)
    instance_eval("#{box_value}#{COMPARE_METHODS[method_name]}#{condition_value}")
  end
end
