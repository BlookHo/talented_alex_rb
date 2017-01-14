require './source/rules_applier'
require './source/parser'
require './source/constants'
require './source/checkout'
require './source/product'
require './source/rule'

RSpec.describe RulesApplier do
  describe 'checkout scan product code' do
    let(:rules_filepath) { RULES_FILE }
    let(:products_filepath) { PRODUCTS_FILE }
    let(:pricing_rules) { Parser.load_rules(rules_filepath) }
    let(:products) { Parser.load_products(products_filepath) }
    let(:products_inited) { Products.init(products) }

    context 'check results after scanning of product with code :AP1' do
      let(:co) { Checkout.new(pricing_rules) }
      let(:cart_content) { co.cart_content }
      let(:prices) { co.prices }

      describe 'checkout attributes after rules & products load' do
        it 'check co.cart_content before scan' do
          expect(cart_content).to eq({})
        end
        it 'check co.prices before scan' do
          expect(prices).to eq({})
        end
      end
    end

    context 'scan of two same products :AP1 - no rules apply' do
      let(:product_code) { :AP1 }
      let(:co) { Checkout.new(pricing_rules) }
      let(:cart_content) { co.cart_content }
      let(:prices) { co.prices }

      before do
        co.scan(product_code)
        co.scan(product_code)
      end

      describe 'checkout attributes after rules & products loading before scan' do
        it 'check co.cart_content' do
          p "products = #{products}"
          expect(co.cart_content).to eq( AP1: 2 )
        end
        it 'check co.prices before scan' do
          expect(co.prices).to eq( AP1: 5.0 )
        end
        it 'check total price of the cart after scanning' do
          expect(co.total).to eq(10.0)
        end
      end
    end

    context 'scan of three same products :AP1 - 2nd rule apply' do
      let(:product_code) { :AP1 }
      let(:co) { Checkout.new(pricing_rules) }
      before do
        co.scan(product_code)
        co.scan(product_code)
        co.scan(product_code)
      end

      describe 'checkout attributes after  after scanning and 2nd rule apply' do
        it 'check co.cart_content' do
          p "products = #{products}"
          expect(co.cart_content).to eq( AP1: 3 )
        end
        it 'check co.prices before scan' do
          expect(co.prices).to eq( AP1: 4.5 )
        end
        it 'check total price of the cart after scanning and 2nd rule apply' do
          expect(co.total).to eq(13.5)
        end
      end
    end

    context 'scan of different products: three :AP1 and one :FR1 - both rules apply' do
      let(:product_code_one) { :AP1 }
      let(:product_code_two) { :FR1 }
      let(:co) { Checkout.new(pricing_rules) }
      before do
        co.scan(product_code_one)
        co.scan(product_code_one)
        co.scan(product_code_one)
        co.scan(product_code_two)
      end

      describe 'checkout attributes after after scanning and both rules apply' do
        it 'check co.cart_content' do
          p "products = #{products}"
          expect(co.cart_content).to eq( AP1: 3, FR1: 2 )
        end
        it 'check co.prices before scan' do
          expect(co.prices).to eq( AP1: 4.5, FR1: 1.555 )
        end
        it 'check total price of the cart after scanning and both rules apply' do
          expect(co.total).to eq(16.61)
        end
      end
    end
  end
end
