require 'rspec'
require 'sample'

describe Sample do
  let(:sample) { Sample.new }
  
  describe '#hello' do
    it "returns hello" do
      expect(sample.hello).to eq('hello')
    end
  end
  
  describe '#world' do
    it "returns world" do
      expect(sample.world).to eq('world')
    end
  end
end