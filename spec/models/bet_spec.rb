# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bet, type: :model do
  describe 'association' do
    it { should belong_to :user }
    it { should belong_to :match }
    it { should belong_to(:team).optional }
  end
end
