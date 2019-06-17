# frozen_string_literal: true

RSpec.describe AddPlayoffsToTournament, type: :interactor do
  let(:group_stage_tournament_context) do
    AddPlayoffsToTournament.call(tournament: @group_stage_tournament, teams: @group_stage_tournament.teams)
  end

  let(:playoff_stage_tournament_context) do
    AddPlayoffsToTournament.call(tournament: @playoff_stage_tournament, teams: @playoff_stage_tournament.teams)
  end

  let(:full_tournament_context) do
    AddPlayoffsToTournament.call(tournament: @full_tournament, teams: @full_tournament.teams)
  end

  before do
    @group_stage_tournament = create(:group_stage_tournament, stage_count: 0, group_count: 0)
    @playoff_stage_tournament = create(:stageless_tournament)
    @full_tournament = create(:dummy_stage_tournament)
    @stages = create_list(:stage, 3)
  end

  context 'PlayoffStageService mocked' do
    before do
      expect(class_double('PlayoffStageService').as_stubbed_const(transfer_nested_constants: true))
        .to receive(:generate_playoff_stages)
        .and_return(@stages)
    end

    context 'Playoff only tournament' do
      it 'succeeds' do
        expect(playoff_stage_tournament_context).to be_a_success
      end

      it 'adds playoffs to the tournament' do
        test = playoff_stage_tournament_context.tournament.stages
        expect(test).to match_array(@stages)
      end
    end

    context 'GroupStage tournament' do
      it 'succeeds' do
        expect(group_stage_tournament_context).to be_a_success
      end

      it 'adds playoffs to the tournament' do
        test = group_stage_tournament_context.tournament.stages[1..-1]
        expect(test).to match_array(@stages)
      end
    end
  end

  context 'playoff generation fails' do
    before do
      expect(class_double('PlayoffStageService').as_stubbed_const(transfer_nested_constants: true))
        .to receive(:generate_playoff_stages)
        .and_return(nil)
    end

    it 'fails' do
      test = playoff_stage_tournament_context.failure?
      expect(test).to eq(true)
    end
  end

  context 'Tournament where playoffs are already generated' do
    it 'does not add playoff stages' do
      test = full_tournament_context.failure?
      expect(test).to eq(true)
    end
  end
end
