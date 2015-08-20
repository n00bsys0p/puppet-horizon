require 'spec_helper'
describe 'horizon' do

  context 'with defaults for all parameters' do
    it { should contain_class('horizon') }
  end
end
