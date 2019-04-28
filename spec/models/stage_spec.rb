# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe 'association' do
    it { should belong_to :tournament }
    it { should have_many :matches }
    it { should have_many :groups }
  end

  it 'has a valid factory' do
    expect(build(:stage)).to be_valid
    expect(build(:group_stage)).to be_valid
  end
end
