require 'rails_helper'

RSpec.describe Search::Issue do

  it 'returns all published issues' do
    create_list(:draft_issue, 2) # non-matching rows

    issues = create_list(:published_issue, 2)
    search = described_class.new

    expect(search.results).to contain_exactly(*issues)
  end

  it 'filters by sprint' do
    create_list(:published_issue, 2) # non-matching rows

    sprint = create(:sprint)
    updates = create_list(:published_sprint_update, 2, sprint: sprint)
    expected = updates.map {|update|
      create(:issue, sprint_update: update)
    }

    search = described_class.new(params: { sprint_id: sprint.id })

    expect(search.results).to contain_exactly(*expected)
  end

  it 'filters by group' do
    create_list(:published_issue, 2) # non-matching rows

    group = create(:group)
    teams = create_list(:team, 2, group: group)
    updates = teams.map {|team|
      create(:published_sprint_update, team: team)
    }
    expected = updates.map {|update|
      create(:issue, sprint_update: update)
    }

    search = described_class.new(params: { group_id: group.id })

    expect(search.results).to contain_exactly(*expected)
  end

  it 'filters by whether an identifier is present' do
    create_list(:published_issue, 2, identifier: nil) # non-matching rows

    expected = create_list(:published_issue, 3, identifier: '123456')
    search = described_class.new(params: { identifier: true })

    expect(search.results).to contain_exactly(*expected)
  end

end
