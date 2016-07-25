require 'spec_helper'
require 'pathname'

module Template
  describe JsonStreamParser do

    subject{ JsonStreamParser.new }

    let(:file){
      File.new('spec/fixtures/json_stream_parser_fixture.json')
    }
    items = []

    describe '#parse_json_file_at_depth' do
      before do
        items = []
        subject.parse_json_file_at_depth(file, depth) do |item|
          items << item
        end
      end

      context 'at depth 2' do
        let(:depth){2}
        it 'should parse objects correctly' do
          expect(items.length).to eq(4)
          expect(items[0]).to eq({"depth3-1"=>"world"})
          expect(items[1]).to eq({"depth3-2"=>"123", "depth3-3"=>{"depth4-1"=>{}, "depth4-2"=>{"depth5"=>4}, "depth4-3"=>{}}})
          expect(items[2]).to eq({"depth3-4"=>"555"})
          expect(items[3]).to eq({"depth3-5"=>"Hello"})
        end
      end

      context 'at a deeper depth' do
        let(:depth){4}
        it 'should parse objects correctly' do
          expect(items.length).to eq(3)
          expect(items[0]).to eq({})
          expect(items[1]).to eq({"depth5"=>4 })
          expect(items[2]).to eq({})
        end
      end
    end
  end
end
