require 'rails_helper'

RSpec.describe Quarters::QuarterNavigationComponent, type: :component do
  let(:quarter) { create(:quarter, start_on: '2022-01-01', end_on: '2022-03-30') }
  let(:previous_quarter) { create(:quarter) }
  let(:next_quarter) { create(:quarter) }
  let(:controller_name) { 'quarters' }
  let(:action_name) { 'show' }

  before(:each) do
    render_inline(described_class.new(quarter: quarter,
                                      previous_quarter: previous_quarter,
                                      next_quarter: next_quarter,
                                      controller_name: controller_name,
                                      action_name: action_name)).to_html
  end

  it 'renders the dates' do
    expect(rendered_component).to have_css('.sprint-navigation__dates', text: "\nJan  1\nto\nMar 30 2022")
  end

  describe 'previous quarter' do
    context 'the previous quarter exists' do
      let(:previous_quarter) { create(:quarter) }

      it 'links to the quarter' do
        expect(rendered_component).to have_link('Previous quarter', href: /\/#{previous_quarter.to_param}$/)
      end
    end

    context 'the previous quarter is empty' do
      let(:previous_quarter) { nil }

      it 'does not link to the quarter' do
        expect(rendered_component).to_not have_link('Previous quarter')
        expect(rendered_component).to have_css(
          '.sprint-navigation__button--previous.sprint-navigation__button--disabled',
        )
      end
    end
  end

  describe 'next quarter' do
    context 'the next quarter exists' do
      let(:next_quarter) { create(:quarter) }

      it 'links to the quarter' do
        expect(rendered_component).to have_link('Next quarter', href: /\/#{next_quarter.to_param}$/)
      end
    end

    context 'the previous quarter is empty' do
      let(:next_quarter) { nil }

      it 'does not link to the quarter' do
        expect(rendered_component).to_not have_link('Next quarter')
        expect(rendered_component).to have_css('.sprint-navigation__button--next.sprint-navigation__button--disabled')
      end
    end
  end

  context 'when viewing the commitments index' do
    let(:controller_name) { 'commitments' }
    let(:action_name) { 'index' }

    it 'links to the commitments index for the next and previous quarters' do
      expect(rendered_component).to have_link('Previous quarter', href: /\/#{previous_quarter.to_param}\/commitments$/)
      expect(rendered_component).to have_link('Next quarter', href: /\/#{next_quarter.to_param}\/commitments$/)
    end
  end
end
