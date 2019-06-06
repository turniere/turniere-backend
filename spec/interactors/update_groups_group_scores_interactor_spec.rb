# frozen_string_literal: true

RSpec.describe UpdateGroupsGroupScores, type: :interactor do
  before do
    @group = create(:group)
    @group_scores = create_list(:group_score, 2)
  end

  context 'save succeeds' do
    let(:context) do
      UpdateGroupsGroupScores.call(group: @group)
    end

    before do
      allow(GroupStageService)
        .to receive(:update_group_scores).with(@group)
                                         .and_return(@group_scores)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the objects to save' do
      expect(context.object_to_save).to eq(@group_scores)
    end
  end

  context 'exception is thrown' do
    let(:context) do
      UpdateGroupsGroupScores.call(group: @group)
    end
    before do
      allow(GroupStageService)
        .to receive(:update_group_scores).with(@group)
                                         .and_throw('This failed :(')
    end

    it 'fails' do
      test = context.failure?
      expect(test).to eq(true)
    end
  end
end
