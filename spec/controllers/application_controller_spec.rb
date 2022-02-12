require 'rails_helper'

RSpec.describe ApplicationController, type: :controller, skip_login: true do
  context 'with an example subclass controller' do
    controller(ApplicationController) do
      def index
        render plain: nil, status: :ok
      end
    end

    describe '#authenticate!' do
      let(:user) { create(:user) }

      context 'when signed in' do
        before(:each) do
          @request.session[:user_id] = user.id
        end

        it 'does not redirect' do
          get :index
          expect(response.status).to eq(200)
        end
      end

      context 'when not signed in' do
        before(:each) do
          @request.session[:user_id] = nil
        end

        it 'redirects to the sign in page' do
          get :index
          expect(response).to redirect_to(new_invitation_path)
        end
      end
    end
  end

  describe '#signed_in?' do
    subject { controller.send(:signed_in?) }

    context 'when the signed in user is present' do
      before(:each) do
        controller.stubs(:signed_in_user).returns(User.new)
      end

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'when the signed in user is not present' do
      before(:each) do
        controller.stubs(:signed_in_user).returns(nil)
      end

      it 'is false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#signed_in_user' do
    subject { controller.send(:signed_in_user) }

    context 'with the session user_id present' do
      let(:user) { create(:user) }

      before(:each) do
        controller.stubs(:session).returns({ user_id: user.id })
      end

      it 'returns the user' do
        expect(subject).to eq(user)
      end
    end

    context 'with no session user_id present' do
      before(:each) do
        controller.stubs(:session).returns({})
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'with an invalid session user_id' do
      let(:session) { { user_id: 123456 } }

      before(:each) do
        controller.stubs(:session).returns(session)
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end

      it 'resets the session user_id' do
        expect { subject }.to change { session[:user_id] }.to(nil)
      end
    end
  end

  describe '#signed_in_admin?' do
    subject { controller.send(:signed_in_admin?) }

    context 'when the signed in user is an admin' do
      before(:each) do
        controller.stubs(:signed_in_user).returns(build(:admin_user))
      end

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'when the signed in user is not an admin' do
      before(:each) do
        controller.stubs(:signed_in_user).returns(build(:user))
      end

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'when the signed in user is not present' do
      before(:each) do
        controller.stubs(:signed_in_user).returns(nil)
      end

      it 'is false' do
        expect(subject).to be_falsey
      end
    end
  end
end
