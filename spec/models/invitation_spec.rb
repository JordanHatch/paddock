require 'rails_helper'

RSpec.describe Invitation do
  describe '#valid?', skip_permitted_domains: true do
    before(:each) do
      Paddock.permitted_domains = 'example.org;example.com'
    end

    context 'with a permitted domain' do
      let(:email) { 'foo@example.org' }

      it 'is valid' do
        subject.email = email

        expect(subject).to be_valid
      end
    end

    context 'with another domain' do
      let(:email) { 'foo@evil.org' }

      it 'is not valid' do
        subject.email = email

        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:email)
      end
    end
  end
end
