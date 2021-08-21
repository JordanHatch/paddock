require 'rails_helper'

RSpec.describe InvitationsHelper, type: :helper do
  describe '#invitation_user_initials' do
    subject { helper.invitation_user_initials(email) }

    context 'with a firstname.lastname email address' do
      let(:email) { 'test.user@example.org' }

      it 'returns the initials' do
        expect(subject).to eq('TU')
      end
    end

    context 'with more than two dots in the email' do
      let(:email) { 'test.user.email@example.org' }

      it 'returns only the first two initials' do
        expect(subject).to eq('TU')
      end
    end

    context 'with no dots in the email' do
      let(:email) { 'test@example.org' }

      it 'returns only the first initial' do
        expect(subject).to eq('T')
      end
    end
  end
end
