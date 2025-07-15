# frozen_string_literal: true

require 'spec_helper.rb'
require 'rails_helper.rb'

describe ToolbarHelper do
  describe '#sova_link_from_record' do
    context 'when a resource' do
      let(:record_type) { 'resource' }

      context 'when a standard ead_id' do
        let(:record_id) {'EAD.123'}
      
        it "returns '/record/{downcased-eadid}'" do
          expect(ToolbarHelper::sova_link_from_record(record_id, record_type)).to eq('/record/ead.123')
        end
      end

      context 'when ead_id has trailing whitespace' do
        let(:record_id) {'EAD.123 '}
      
        it 'strips the trailing whitespace' do
          expect(ToolbarHelper::sova_link_from_record(record_id, record_type)).to eq('/record/ead.123')
        end
      end
    end

    context 'when an archival object' do
      let(:record_id) {'EAD.123_ref1'}
      let(:record_type) { 'archival_object' }

      it "returns '/record/{downcased-eadid}/{refid}'" do
        expect(ToolbarHelper::sova_link_from_record(record_id, record_type)).to eq('/record/ead.123/ref1')
      end
    end
  end
end
