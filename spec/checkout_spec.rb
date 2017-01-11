require './source/checkout'
# require "rules/buy_one_get_one_fruit_tea"
# require "rules/discount_on_apples"

# RSpec.describe Checkout , focus: false do
#
#   context 'when using no rules' do
#     let(:checkout) { Checkout.new }
#
#     describe "#scan" do
#       it 'scans an item' do
#         expect(checkout.scan(fruit_tea_item)).to eq(true)
#       end
#     end
#
#     describe "#total" do
#       it 'returns the total price of all items' do
#         checkout.scan(fruit_tea_item)
#         checkout.scan(apple_item)
#
#         expect(checkout.total).to eq(8.11)
#       end
#     end
#   end
#
#   context 'when using rules' do
#     let(:checkout) { Checkout.new(rules: [Rules::BuyOneGetOneFruitTea, Rules::DiscountOnApples]) }
#     let(:checkout_fruit_tea) do
#       checkout.scan(fruit_tea_item)
#       checkout.scan(apple_item)
#       checkout.scan(fruit_tea_item)
#       checkout
#     end
#
#     describe '#total_rules' do
#       it 'returns the total of all rules' do
#         expect(checkout_fruit_tea.total_rules).to eq(-3.11)
#       end
#     end
#
#     describe '#total' do
#       it 'returns the total with the total of rules applied' do
#         expect(checkout_fruit_tea.total).to eq(8.11)
#       end
#     end
#   end
# end
