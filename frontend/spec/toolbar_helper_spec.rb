# frozen_string_literal: true

require "#{ASUtils.find_base_directory}/frontend/spec/spec_helper"
require "#{ASUtils.find_base_directory}/frontend/spec/rails_helper"

describe ToolbarHelper do
  describe '#sova_link_from_record' do
    context 'when a resource' do
      let(:record_id) {'EAD.123'}
      let(:record_type) { 'resource' }

      it "returns '/record/{downcased-eadid}'" do
        expect(ToolbarHelper::sova_link_from_record(record_id, record_type)).to eq('/record/ead.123')
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
