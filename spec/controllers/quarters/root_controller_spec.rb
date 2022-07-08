require 'rails_helper'

RSpec.describe Quarters::RootController, type: :controller do
  describe 'GET index' do
    subject { get :index }

    context 'when a current quarter exists' do
      let(:quarter) { create(:quarter) }
      before(:each) { Quarter.stubs(:current).returns(quarter) }

      it 'redirects to the quarter' do
        expect(subject).to redirect_to(quarter_path(quarter))
      end
    end

    context 'when no current quarter exists but another quarter does' do
      let!(:quarters) { create_list(:quarter, 3) }
      before(:each) { Quarter.stubs(:current).returns(nil) }

      it 'redirects to the first quarter' do
        expect(subject).to redirect_to(quarter_path(quarters.first))
      end
    end

    context 'when no quarters exist' do
      before(:each) { Quarter.stubs(:current).returns(nil) }

      it 'returns a 200' do
        expect(subject).to have_http_status(:ok)
      end
    end
  end
end
