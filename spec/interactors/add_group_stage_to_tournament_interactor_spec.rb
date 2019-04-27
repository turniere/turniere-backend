# frozen_string_literal: true

RSpec.describe AddGroupStageToTournament do
  let(:empty_tournament_context) do
    AddGroupStageToTournament.call(tournament: @empty_tournament, groups: @groups)
  end

  let(:group_stage_tournament_context) do
    AddGroupStageToTournament.call(tournament: @group_stage_tournament, groups: @groups)
  end

  before do
    @empty_tournament = create(:stage_tournament, stage_count: 0)
    @group_stage_tournament = create(:group_stage_tournament)
    @group_stage = create(:group_stage)
    @groups = Hash[1 => create_list(:team, 4), 2 => create_list(:team, 4)].values
  end

  context 'GroupStageService mocked' do
    before do
      expect(class_double('GroupStageService').as_stubbed_const(transfer_nested_constants: true))
        .to receive(:generate_group_stage).with(@groups)
                                          .and_return(@group_stage)
    end

    context 'Empty tournament' do
      it 'context succeeds' do
        expect(empty_tournament_context).to be_a_success
      end

      it 'adds group stage to the tournament' do
        test = empty_tournament_context.tournament.stages.first
        expect(test).to eq(@group_stage)
      end
    end
  end

  context 'playoff generation fails' do
    before do
      expect(class_double('GroupStageService').as_stubbed_const(transfer_nested_constants: true))
        .to receive(:generate_group_stage).with(@groups)
                                          .and_return(false)
    end

    it 'context fails' do
      expect(empty_tournament_context).to be_a_failure
    end
  end

  context 'Tournament where group stage is already generated' do
    it 'does not add group stage' do
      expect(group_stage_tournament_context).to be_a_failure
    end
  end
end