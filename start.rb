require './source/rule'
require './source/constants'
require './source/checkout'


pricing_rules = Rule.load_rules(RULES_FILE)
co = Checkout.new(pricing_rules)

co.scan(:AP1)
co.scan(:AP1)
co.scan(:FR1)
co.scan(:AP1)
# co.scan(:FR1)
# co.scan(:CF1)
# co.scan(:AP1)
# co.scan(:FR1)
# co.scan(:FR1)
# co.scan(:AP1)
# co.scan(:FR1)

# source('start.rb')
# co.items
# => [:T]
# co.scan(:T)
# [:T, :A, :T]
# ctrl + L - clear irb screen
# p co.items
# p co.analyse_cart
# p co.cart_content
# p co.total(500).round(2)
# p co.prices
