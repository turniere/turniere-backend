# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'association' do
    it { should belong_to :stage }
    it { should have_many :matches }
    it { should have_many :group_scores }
  end

  it 'has a valid factory' do
    expect(build(:group)).to be_valid
  end
end
