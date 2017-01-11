require 'json'

class Rule
  attr_reader :title, :conditions, :cart_actions, :product_pricing

  def initialize(rule)
    @title = rule['title']
    @conditions = rule['conditions']
    @cart_actions = rule['cart_actions']
    @product_pricing = rule['product_pricing']
  end

# Этот метод используется только в сидах. Зачем он в этом классе?
  def self.load_rules(filepath)
    JSON.parse(File.read(filepath))['rules']
  end

  def satisfies_conditions?(cart_content, item)
    to_apply_rule = false
    conditions.each do |condition|
      to_apply_rule = should_be_applied?(condition, cart_content, item)
      return false unless to_apply_rule
    end
    to_apply_rule
    # http://apidock.com/ruby/Enumerable/all%3F
    # return conditions.all? { |condition| apply?(condition, cart_content, item) }
  end

  def should_be_applied?(condition, cart_content, item)
    to_apply(condition, cart_content) if item == condition['product_name'].to_sym
  end

# если метод возвращает булиан, то стоит его называть с ?
# и есть to_apply? то непонятно, в чем разница по смыслу применения между этим и apply? методом
  def to_apply(condition, cart_content)
    to_apply = false
    compare_method_name = condition['comparison'].to_sym
    if COMPARE_METHODS.keys.include?(compare_method_name)
      to_apply = condition_eval?(
        compare_method_name, cart_content[condition['product_name'].to_sym], condition['qty'].to_i
      )
    else
      # почему не вызов validation error/аналог?
      puts 'Validate your rule!'
    end
    to_apply
  end

  #  сходу непонятно, что тут происходит. как минимум нужен коммент с примером
  # value_satisfies_conditional?
  def condition_eval?(method_name, box_value, condition_value)
    instance_eval("#{box_value}#{COMPARE_METHODS[method_name]}#{condition_value}")
  end
end
