# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validation' do
    it { should validate_presence_of :name }
  end

  describe 'association' do
    it { should belong_to :tournament }
    it { should have_one :group_score }
  end
end
