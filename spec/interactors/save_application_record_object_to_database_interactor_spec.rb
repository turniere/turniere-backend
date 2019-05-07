# frozen_string_literal: true

RSpec.describe SaveApplicationRecordObject do
  before do
    @tournament = create(:tournament)
  end

  context 'save succeeds' do
    let(:context) do
      SaveApplicationRecordObject.call(object_to_save: @tournament)
    end
    before do
      expect_any_instance_of(Tournament)
        .to receive(:save).and_return(true)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the tournament' do
      expect(context.object_to_save).to eq(@tournament)
    end
  end

  context 'save fails' do
    let(:context) do
      SaveApplicationRecordObject.call(object_to_save: @tournament)
    end
    before do
      expect_any_instance_of(Tournament)
        .to receive(:save).and_return(false)
    end

    it 'fails' do
      test = context.failure?
      expect(test).to eq(true)
    end
  end
end
