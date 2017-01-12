require 'json'

class RulesParser

  def self.load_rules(filepath)
    JSON.parse(File.read(filepath))['rules']
  end
end