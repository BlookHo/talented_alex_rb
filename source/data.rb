PRICE_LIST = { FR1: 3.11, AP1: 5.00, CF1: 11.23 }.freeze
PRODUCTS = { FR1: 'Fruit tea', AP1: 'Apple', CF1: 'Coffee' }.freeze

# Rules methods
COMPARE_METHODS = {
  more: '>', more_and_equal: '>=', less_and_equal: '<=', less: '<', equal: '=='
}.freeze
ACTIONS_METHODS = { add: '+', multiple: '*', set_to: '=' }.freeze
PRICING_METHODS = { discount: '%', set_to: '=', less_to: '-', divide: '/' }.freeze
