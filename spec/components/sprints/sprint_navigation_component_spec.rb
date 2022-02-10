require 'rails_helper'

RSpec.describe Sprints::SprintNavigationComponent, type: :component do
  let(:sprint) { create(:sprint, start_on: '2022-01-01', end_on: '2022-01-14') }
  let(:team) { create(:team) }
  let(:previous_sprint) { create(:sprint) }
  let(:next_sprint) { create(:sprint) }
  let(:controller_name) { 'sprints' }
  let(:action_name) { 'show' }

  let(:team_active_in_previous_sprint) { true }
  let(:team_active_in_next_sprint) { true }

  def render_component
    render_inline(described_class.new(sprint: sprint,
                                      team: team,
                                      previous_sprint: previous_sprint,
                                      next_sprint: next_sprint,
                                      controller_name: controller_name,
                                      action_name: action_name)).to_html
  end

  def expect_no_link_to_previous_sprint
    expect(rendered_component).to_not have_link('Previous sprint')
    expect(rendered_component).to have_css(
      '.sprint-navigation__button--previous.sprint-navigation__button--disabled',
    )
  end

  def expect_no_link_to_next_sprint
    expect(rendered_component).to_not have_link('Next sprint')
    expect(rendered_component).to have_css(
      '.sprint-navigation__button--next.sprint-navigation__button--disabled',
    )
  end

  before(:each) do
    if team.present?
      team.stubs(:active_in_sprint?).with(previous_sprint).returns(team_active_in_previous_sprint)
      team.stubs(:active_in_sprint?).with(next_sprint).returns(team_active_in_next_sprint)
    end

    render_component
  end

  it 'renders the dates' do
    expect(rendered_component).to have_css('.sprint-navigation__dates', text: "\nJan  1\nto\nJan 14 2022")
  end

  describe 'previous sprint' do
    context 'with a team present' do
      let(:team) { create(:team) }

      context 'the previous sprint exists' do
        let(:previous_sprint) { create(:sprint) }

        context 'the team is active in the previous sprint' do
          let(:team_active_in_previous_sprint) { true }

          it 'links to the previous sprint' do
            expect(rendered_component).to have_link('Previous sprint')
          end
        end

        context 'the team is not active in the previous sprint' do
          let(:team_active_in_previous_sprint) { false }

          it 'does not link to the previous sprint' do
            expect_no_link_to_previous_sprint
          end
        end
      end

      context 'the previous sprint is empty' do
        let(:previous_sprint) { nil }

        it 'does not link to the sprint' do
          expect_no_link_to_previous_sprint
        end
      end
    end

    context 'with no team present' do
      let(:team) { nil }

      context 'the previous sprint exists' do
        let(:previous_sprint) { create(:sprint) }

        it 'links to the previous sprint' do
          expect(rendered_component).to have_link('Previous sprint', href: /\/#{previous_sprint.to_param}$/)
        end
      end

      context 'the previous sprint does not exist' do
        let(:previous_sprint) { nil }

        it 'does not link to the previous sprint' do
          expect_no_link_to_previous_sprint
        end
      end
    end
  end

  describe 'next sprint' do
    context 'with a team present' do
      let(:team) { create(:team) }

      context 'the next sprint exists' do
        let(:next_sprint) { create(:sprint) }

        context 'the team is active in the next sprint' do
          let(:team_active_in_next_sprint) { true }

          it 'links to the next sprint' do
            expect(rendered_component).to have_link('Next sprint')
          end
        end

        context 'the team is not active in the next sprint' do
          let(:team_active_in_next_sprint) { false }

          it 'does not link to the next sprint' do
            expect_no_link_to_next_sprint
          end
        end
      end

      context 'the next sprint is empty' do
        let(:next_sprint) { nil }

        it 'does not link to the sprint' do
          expect_no_link_to_next_sprint
        end
      end
    end

    context 'with no team present' do
      let(:team) { nil }

      context 'the next sprint exists' do
        let(:next_sprint) { create(:sprint) }

        it 'links to the next sprint' do
          expect(rendered_component).to have_link('Next sprint', href: /\/#{next_sprint.to_param}$/)
        end
      end

      context 'the next sprint does not exist' do
        let(:next_sprint) { nil }

        it 'does not link to the next sprint' do
          expect_no_link_to_next_sprint
        end
      end
    end
  end

  context 'when viewing the updates controller' do
    let(:controller_name) { 'updates' }
    let(:team) { create(:team) }

    it 'links to the sprint update for the current team' do
      expect(rendered_component).to have_link('Previous sprint',
                                              href: /\/#{previous_sprint.to_param}\/#{team.to_param}$/)
      expect(rendered_component).to have_link('Next sprint',
                                              href: /\/#{next_sprint.to_param}\/#{team.to_param}$/)
    end
  end

  context 'when viewing the issues list' do
    let(:controller_name) { 'sprints' }
    let(:action_name) { 'issues' }

    it 'links to the issues list for the sprint' do
      expect(rendered_component).to have_link('Previous sprint',
                                              href: /\/#{previous_sprint.to_param}\/issues$/)
      expect(rendered_component).to have_link('Next sprint',
                                              href: /\/#{next_sprint.to_param}\/issues$/)
    end
  end
end
