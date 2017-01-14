require './source/rule'
require './source/parser'
require './source/constants'

RSpec.describe Parser do
  describe 'rules loading with #load_rules' do
    let(:filepath) { RULES_FILE }

    context 'load rules from json file' do
      let(:rules) { Parser.load_rules(filepath) }
      describe 'all rules loaded' do
        it 'scans rules' do
          expect(rules.size).to eq(2)
        end
      end
    end

    context 'correctness of loaded rules data' do
      let(:first_rule) { Parser.load_rules(filepath)[0] }
      let(:rule) { Rule.new(first_rule) }
      describe 'load and create first rule object' do
        it 'check pricing_actions keys attributes of first rule created' do
          expect(rule.pricing_actions[0].keys).to eq(%w(product_code action qty))
        end
        it 'check pricing_actions values attributes of first rule created' do
          expect(rule.pricing_actions[0].values).to eq(['FR1', 'divide', 2])
        end
      end
    end
  end

  describe 'products loading with #load_products' do
    let(:filepath) { PRODUCTS_FILE }

    context 'load products from json file' do
      let(:products) { Parser.load_products(filepath) }
      describe 'all products loaded' do
        it 'scans products' do
          expect(products.size).to eq(3)
        end
      end
    end

    context 'correctness of loaded products data' do
      let(:second_product) { Parser.load_products(filepath)[1] }
      let(:product) { Product.new(second_product) }
      describe 'load and create second product object' do
        it 'check attributes keys of second product created' do
          expect(product.products_attributes.keys).to eq(%w(code name price))
        end
        it 'check attributes values of second product created' do
          expect(product.products_attributes.values).to eq(['AP1', 'Apple', 5.0])
        end
      end
    end
  end
end
