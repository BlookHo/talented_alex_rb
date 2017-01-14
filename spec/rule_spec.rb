require './source/rule'
require './source/parser'
require './source/constants'

RSpec.describe Parser do
  context 'check conditions of rule apply - method #satisfies_conditions?' do
    let(:first_rule) { Parser.load_rules(RULES_FILE)[0] }
    let(:rule) { Rule.new(first_rule) }
    let(:cart_content) { { AP1: 3, FR1: 2 } }
    describe 'create rule object' do
      it 'check rule conditions keys  of first rule created' do
        expect(rule.conditions[0].keys).to eq(%w(product_code comparison qty))
      end
      it 'check rule conditions values  of first rule created' do
        expect(rule.conditions[0].values).to eq(['FR1', 'more', 0])
      end
    end

    describe 'check rule apply to appropriate product' do
      let(:to_apply_rule) { rule.satisfies_conditions?(cart_content, product_code) }
      let(:product_code) { :FR1 }
      it 'check rule conditions' do
        expect(to_apply_rule).to eq(true)
      end
    end

    describe 'check rule should not apply to different product' do
      let(:to_apply_rule) { rule.satisfies_conditions?(cart_content, product_code) }
      let(:product_code) { :AP1 }
      it 'check rule conditions' do
        expect(to_apply_rule).to eq(false)
      end
    end
  end
end
