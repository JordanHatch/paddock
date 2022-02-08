require 'rails_helper'

RSpec.describe Quarters::Commitments::TeamsForm do
  describe 'callback:deserialize_model' do
    let(:commitment) { create(:commitment, teams: teams) }
    let(:form) { described_class.new(commitment) }

    context 'with teams present' do
      let(:teams) { create_list(:team, 2) }

      it 'deserializes the team IDs into the team_ids attribute' do
        expected = teams.map(&:id)

        expect(form.team_ids).to contain_exactly(*expected)
      end
    end

    context 'with no teams present' do
      let(:teams) { [] }

      it 'deserializes the team IDs into the team_ids attribute' do
        expect(form.team_ids).to eq([])
      end
    end
  end
end
