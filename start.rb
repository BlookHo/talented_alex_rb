require './source/constants'
require './source/checkout'
require './source/parser'
require 'byebug'

pricing_rules = Parser.load_rules(RULES_FILE)
Parser.load_products(PRODUCTS_FILE)
