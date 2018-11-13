# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupScore, type: :model do
  describe 'association' do
    it { should belong_to :team }
  end
end
