require 'rails_helper'

RSpec.describe Sprints::UpdatePreviewComponent, type: :component do
  let(:team) { create(:team) }
  let(:sprint) { create(:sprint) }
  let(:sprint_update) do
    create(:published_sprint_update, team: team, sprint: sprint, delivery_status: :green, okr_status: :amber)
  end
  let!(:issues) { create_list(:issue, 3, sprint_update: sprint_update) }

  let(:team_summary) { build(:team_summary, team: team, sprint: sprint, sprint_update: sprint_update) }

  subject! do
    render_inline(described_class.new(team_summary: team_summary))
  end

  it 'renders the basic team summary details' do
    expect(rendered_component).to have_css('.sprints-update-preview__team-name', text: team.name)
    expect(rendered_component).to have_link(href: /\/sprints\/#{sprint.id}\/#{team.to_param}$/)
  end

  describe 'indicators' do
    context 'for a published sprint update' do
      it 'renders the indicators' do
        expect(rendered_component).to have_css('.indicator-list__indicator', text: 'Delivery Green', normalize_ws: true)
        expect(rendered_component).to have_css('.indicator-list__indicator', text: 'OKRs Amber', normalize_ws: true)
        expect(rendered_component).to have_css('.indicator-list__indicator', text: '3 issues')
      end
    end

    context 'for a draft sprint update' do
      let(:sprint_update) { create(:draft_sprint_update, team: team, sprint: sprint) }

      it 'shows a placeholder message' do
        expect(rendered_component).to have_css('.indicator-list', text: 'Awaiting submission')
      end
    end
  end

  context 'when the team is blank' do
    let(:team_summary) { build(:team_summary, team: nil, id: nil, name: nil, start_on: nil, slug: nil, group_id: nil) }

    it 'does not render' do
      expect(rendered_component).to_not have_selector('body')
    end
  end

  context 'when the sprint is blank' do
    let(:team_summary) { build(:team_summary, sprint: nil) }

    it 'does not render' do
      expect(rendered_component).to_not have_selector('body')
    end
  end

  context 'when the update is blank' do
    let(:team_summary) do
      build(:team_summary, team: team,
                           sprint: sprint,
                           sprint_update: nil,
                           update_id: nil,
                           state: nil,
                           delivery_status: nil,
                           okr_status: nil,
                           issue_count: 0)
    end

    it 'renders with a placeholder message' do
      expect(rendered_component).to have_css('.sprints-update-preview__team-name', text: team.name)
      expect(rendered_component).to have_link(href: /\/sprints\/#{sprint.id}\/#{team.to_param}$/)
      expect(rendered_component).to have_css('.indicator-list', text: 'Awaiting submission')
    end
  end
end
