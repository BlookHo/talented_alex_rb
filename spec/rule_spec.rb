require './source/rule'
require './source/constants'

RSpec.describe Rule do

  context 'load rules from file' do
    let(:filepath) { RULES_FILE }
    let(:rules) { Rule.load_rules(filepath) }

    describe '#load_rules' do
      it 'scans an item' do
        expect(rules.size).to eq(2)
      end
    end

  end

  context 'check conditions of rule apply' do
    let(:first_rule) { Rule.load_rules(RULES_FILE)[0] }
    let(:rule) { Rule.new(first_rule) }
    let(:condition) { {'product_name'=>'AP1', 'comparison'=>'more_and_equal', 'qty'=>'3'} }
    let(:cart_content) { {:AP1=>3, :FR1=>2} }
    let(:item) { :AP1 }

    describe 'create rule object' do
      it 'check rule conditions' do
        expect(rule.conditions).to eq([{'product_name'=>'FR1', 'comparison'=>'more', 'qty'=>'0'}])
      end
    end

    describe 'check rule apply' do
      let(:to_apply_rule) { rule.satisfies_conditions?(cart_content, item) }
      it 'check rule conditions' do
        expect(to_apply_rule).to eq(true)
      end
    end


  end

end

