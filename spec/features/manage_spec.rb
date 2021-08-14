require 'rails_helper'

RSpec.describe 'the manage section', type: :feature do
  describe 'accessing the section' do
    context 'as an admin user', admin_user: true do
      it "displays a 'Manage' tag" do
        visit root_path
        within 'header.app' do
          expect(page).to have_link('Manage')
        end
      end

      it 'renders the page' do
        visit manage_root_path
        expect(page).to have_content('Manage')
      end
    end

    context 'as a regular user', admin_user: false do
      it "doesn't display a 'Manage' tag" do
        visit root_path
        within 'header.app' do
          expect(page).to_not have_link('Manage')
        end
      end

      it 'returns a 404 error' do
        visit manage_root_path
        expect(page).to have_http_status(404)
      end
    end
  end
end
