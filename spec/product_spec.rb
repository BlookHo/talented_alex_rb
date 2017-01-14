require './source/rule'
require './source/parser'
require './source/constants'

RSpec.describe Product do
  describe 'products correctly loaded and respond to methods' do
    let(:filepath) { PRODUCTS_FILE }

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

    context 'check - method #get_product_price' do
      let(:product_code) { :AP1 }
      describe 'get correct price of the product' do
        let(:price) { Product.get_product_price(product_code) }
        it 'check rule conditions keys  of first rule created' do
          expect(price).to eq(5.00)
        end
      end
    end

    context 'check - method #get_product_price' do
      let(:product_code) { :AA1 }
      describe 'do not get correct price to uncorrect product' do
        let(:price) { Product.get_product_price(product_code) }
        it 'check rule conditions keys  of first rule created' do
          expect(price).to eq(0)
        end
      end
    end
  end
end
