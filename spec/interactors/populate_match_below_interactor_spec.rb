# frozen_string_literal: true

RSpec.describe PopulateMatchBelow, type: :interactor do
  before do
    @match = create(:match)
    @objects_to_save = [create(:match), create_list(:match_score, 2)]
  end

  context 'no exception' do
    let(:context) do
      PopulateMatchBelow.call(match: @match)
    end
    before do
      allow(PlayoffStageService)
        .to receive(:populate_match_below).with(@match)
                                          .and_return(@objects_to_save)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the objects to save' do
      expect(context.object_to_save).to match_array(@objects_to_save)
    end
  end

  context 'exception is thrown' do
    let(:context) do
      PopulateMatchBelow.call(match: @match)
    end
    before do
      allow(PlayoffStageService)
        .to receive(:populate_match_below).with(@match)
                                          .and_throw('This failed :(')
    end

    it 'fails' do
      test = context.failure?
      expect(test).to eq(true)
    end
  end
end
