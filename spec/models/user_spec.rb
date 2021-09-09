require 'rails_helper'

RSpec.describe User do
  describe '.by_case_insensitive_email' do
    let(:user) { create(:user) }

    it 'uses a case-insensitive match for the email field' do
      email = user.email.upcase
      result = described_class.with_case_insensitive_email(email).first

      expect(result).to eq(user)
    end
  end

  describe '#admin?' do
    context 'when an admin user' do
      subject { create(:admin_user) }

      it 'is true' do
        expect(subject).to be_admin
      end
    end

    context 'when a regular user' do
      it 'is false' do
        expect(subject).to_not be_admin
      end
    end
  end
end
