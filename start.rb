require './source/rule'
require './source/constants'
require './source/checkout'
require './source/parser'
require './source/product'
require 'byebug'

pricing_rules = Parser.load_rules(RULES_FILE)
Parser.load_products(PRODUCTS_FILE)

co = Checkout.new(pricing_rules)

co.scan(:AP1)
co.scan(:AP1)
co.scan(:FR1)
co.scan(:AP1)
