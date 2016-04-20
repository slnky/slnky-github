require 'spec_helper'

# describe Slnky::Service::Github do
#   subject { described_class.new('http://localhost:3000', test_config) }
#   let(:test_event) { event_load('test')}
#   let(:created) {event_load('created')}
#   let(:hooks) {event_load('hooks')}
#
#   it 'handles event' do
#     expect(subject.handler(test_event.name, test_event.payload)).to eq(true)
#   end
#
#   it 'handles created' do
#     expect(subject.handle_repo(created.name, created.payload)).to eq(true)
#   end
#
#   it 'handles hooks' do
#     expect(subject.handle_hooks(hooks.name, hooks.payload)).to eq(true)
#   end
# end
