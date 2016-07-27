require 'spec_helper'
require 'httparty'
require 'ostruct'

module Template
  describe ServiceProvider do

    before { ServiceProvider.base_uri 'http://service-provider' }

    context 'test request is successful' do
      let(:test_response) { OpenStruct.new(body: read_fixture('service_provider.json'), code: 200)}
      before do
        allow(subject.class).to receive(:get).with('/index', {:timeout=>5, :headers=>{"Accept"=>"application/json"}}).and_return(test_response)
      end

      it 'returns only active market based contract products' do
        items = ServiceProvider.new.run
        expect(items[0][:id]).to eql(10001)
        expect(items[1][:id]).to eql(10002)
        expect(items[2][:id]).to eql(10003)
      end
    end

    context 'test request fails' do
      before { allow(ServiceProvider).to receive(:get).with('/index', {:timeout=>5, :headers=>{"Accept"=>"application/json"}}).and_raise('this-does-not-exist') }

      subject { lambda { ServiceProvider.new.run } }

      it { should raise_error(ServiceProvider::RequestError) }
    end

    context 'test request results in an unexpected response code' do
      let(:test_response) {OpenStruct.new(body: '', :code => 201)}

      before { allow(ServiceProvider).to receive(:get).with('/index', {:timeout=>5, :headers=>{"Accept"=>"application/json"}}).and_return(test_response) }

      subject { lambda { ServiceProvider.new.run } }
      it { should raise_error(ServiceProvider::UnexpectedResponse) }

    end

    context 'test request results in a successful response code, but an empty body' do
      let(:test_response) {OpenStruct.new(body: '', :code => 200)}

      before { allow(ServiceProvider).to receive(:get).with('/index', {:timeout=>5, :headers=>{"Accept"=>"application/json"}}).and_return(test_response) }

      subject { lambda { ServiceProvider.new.run } }
      it { should raise_error(ServiceProvider::InvalidJSON)}
    end

    context 'test request results in a successful response code, but the JSON parser fails' do
      let(:test_response) {OpenStruct.new(body: 'ss{fd[', :code => 200)}

      before {
        allow(ServiceProvider).to receive(:get).with('/index', {:timeout=>5, :headers=>{"Accept"=>"application/json"}}).and_return(test_response)
        allow_any_instance_of(JsonStreamParser).to receive(:parse_json_file_at_depth).and_raise("I hate your input")
      }

      subject { lambda { ServiceProvider.new.run } }
      it { should raise_error(ServiceProvider::InvalidJSON) }
    end
  end
end