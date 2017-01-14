RULES_FILE = 'rules.json'.freeze
PRODUCTS_FILE = 'products.json'.freeze

# Rule's methods
COMPARE_METHODS = {
  more: '>', more_and_equal: '>=', less_and_equal: '<=', less: '<', equal: '=='
}.freeze
ACTIONS_METHODS = { add: '+', multiple: '*', set_to: '=' }.freeze
PRICING_METHODS = { discount: '%', set_to: '=', less_to: '-', divide: '/' }.freeze
