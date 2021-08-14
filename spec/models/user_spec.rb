require 'rails_helper'

RSpec.describe User do
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
