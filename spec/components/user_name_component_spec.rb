require 'rails_helper'

RSpec.describe UserNameComponent, type: :component do
  before(:each) do
    render_inline(described_class.new(user: user))
  end

  context 'when the user is blank' do
    let(:user) { nil }

    it 'does not render the component' do
      expect(rendered_component).to_not have_selector('body')
    end
  end

  context 'when the user has a name' do
    let(:user) { build(:user) }

    it 'renders the name and email' do
      expect(rendered_component).to have_selector("abbr[title='#{user.email}']", text: user.name)
    end
  end

  context 'when the user has no name' do
    let(:user) { build(:user, name: nil) }

    it 'renders only the email' do
      expect(rendered_component).to have_text(user.email)
    end
  end
end
