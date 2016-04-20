require 'spec_helper'

describe Slnky::Github::Service do
  subject do
    s = described_class.new
    s.client = Slnky::Github::Mock.new
    s
  end
  let(:test_event) { slnky_event('test') }
  let(:created) { slnky_event('created') }
  let(:hooks) { slnky_event('hooks') }

  it 'handles event' do
    # test that the handler method receives and responds correctly
    expect(subject.handle_test(test_event.name, test_event.payload)).to eq(true)
  end

  it 'handles created' do
    expect(subject.handle_repo(created.name, created.payload)).to eq("setup hooks: baxterandthehackers/new-repository")
  end

  it 'handles hooks' do
    expect(subject.handle_hooks(hooks.name, hooks.payload)).to include(Slnky::Data.new({full_name: "shawncatz/test"}))
  end
end
