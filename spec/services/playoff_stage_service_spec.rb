# frozen_string_literal: true

RSpec.describe PlayoffStageService do
  describe 'generates' do
    [
      { amount: 1 },
      { amount: 3 },
      { amount: 4 },
      { amount: 7 },
      { amount: 23 },
      { amount: 33 },
      { amount: 82 },
      { amount: 359 }
    ].each do |parameters|
      it "#{parameters[:amount]} empty matches" do
        amount = parameters[:amount]
        generated_matches = PlayoffStageService.generate_empty_matches amount
        generated_matches.each_index do |i|
          expect(generated_matches[i].not_ready?).to eq(true)
          expect(generated_matches[i].position).to eq(i)
        end
        expect(generated_matches.size).to eq(amount)
      end
    end
  end

  describe 'generates' do
    [
      { stages: 1 },
      { stages: 2 },
      { stages: 3 },
      { stages: 4 },
      { stages: 5 },
      { stages: 6 },
      { stages: 7 },
      { stages: 8 },
      { stages: 9 },
      { stages: 10 }
    ].each do |parameters|
      it "#{parameters[:stages]} stages with matches provided by #generate_empty_matches" do
        amount_of_empty_stages = parameters[:stages]
        empty_stages = PlayoffStageService.generate_stages_with_empty_matches(amount_of_empty_stages)
        expect(empty_stages.size).to eq(amount_of_empty_stages)
        empty_stages.each_index do |i|
          empty_stage = empty_stages[i]
          expected_empty_stages_size = empty_stages.size - 1 - i
          expect(empty_stage.level).to eq(expected_empty_stages_size)
          expect(empty_stage.matches.size).to eq(2**expected_empty_stages_size)
        end
      end
    end
  end

  describe 'generates playoff stages for' do
    [
      { team_size: 4, expected_amount_of_playoff_stages: 2 },
      { team_size: 8, expected_amount_of_playoff_stages: 3 },
      { team_size: 9, expected_amount_of_playoff_stages: 4 },
      { team_size: 10, expected_amount_of_playoff_stages: 4 },
      { team_size: 16, expected_amount_of_playoff_stages: 4 },
      { team_size: 24, expected_amount_of_playoff_stages: 5 },
      { team_size: 32, expected_amount_of_playoff_stages: 5 },
      { team_size: 64, expected_amount_of_playoff_stages: 6 },
      { team_size: 111, expected_amount_of_playoff_stages: 7 }
    ].each do |parameters|
      it "#{parameters[:team_size]} teams" do
        amount_of_teams = parameters[:team_size]
        expected_amount_of_playoff_stages = parameters[:expected_amount_of_playoff_stages]
        teams = build_list(:team, amount_of_teams)
        stages = PlayoffStageService.generate_playoff_stages(teams)
        expect(stages.size).to eq(expected_amount_of_playoff_stages)
        stages.each_index do |i|
          stage = stages[i]
          stage_level = stages.size - i - 1
          expect(stage.level).to eq stage_level
        end
      end
    end
  end
end
