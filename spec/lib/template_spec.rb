require 'spec_helper'

module Template
  describe Template do

    context 'a successful fetch of product information' do

      let(:logger) { double('logger').as_null_object }
      let(:items) { [{id: 1001, name: '1001'}, {id: 1002, name: '1002'}] }

      before do
        allow_any_instance_of(ServiceProvider).to receive(:run).and_return(items)
        allow(subject).to receive(:logger).and_return(logger)
      end

      describe '#run' do
        it 'should get correct items' do
          items = Template.run

          expect(items.length).to eql(2)
        end
      end
    end

    [ServiceProvider::RequestError, ServiceProvider::UnexpectedResponse, ServiceProvider::InvalidJSON].each do |error|

      context "A #{error} is produced when calling the provider" do

        let(:logger) { double('logger').as_null_object }

        before do
          allow_any_instance_of(ServiceProvider).to receive(:run).and_raise(error.new('fetch items error'))
          allow(subject).to receive(:logger).and_return(logger)
        end

        it "should not raise an error" do
          expect(lambda { Template.run }).to_not raise_error
        end

        it "should log an error" do
          expect(logger).to receive(:error).with(/fetch items error/)
          Template.run
        end

      end
    end

  end

end
