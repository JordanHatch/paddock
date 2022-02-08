require 'rails_helper'

RSpec.describe 'managing quarters', type: :feature, admin_user: true do
  it 'can create a new quarter' do
    quarter = build(:quarter)

    visit manage_quarters_path
    click_on 'Add a new quarter'

    fill_in 'Quarter name', with: quarter.name

    select quarter.start_on.year, from: 'quarter[start_on(1i)]'
    select quarter.start_on.strftime('%B'), from: 'quarter[start_on(2i)]'
    select quarter.start_on.day, from: 'quarter[start_on(3i)]'

    select quarter.end_on.year, from: 'quarter[end_on(1i)]'
    select quarter.end_on.strftime('%B'), from: 'quarter[end_on(2i)]'
    select quarter.end_on.day, from: 'quarter[end_on(3i)]'

    choose 'Yes'

    click_on 'Save'

    within '.managed-resource-list' do
      expect(page).to have_content(quarter.name)
    end

    record = Quarter.last
    expect(record.name).to eq(quarter.name)
    expect(record.start_on).to eq(quarter.start_on)
    expect(record.end_on).to eq(quarter.end_on)
    expect(record).to be_editable
  end

  it 'can edit a quarter' do
    quarter = create(:quarter)
    updated_name = 'Updated name'

    visit manage_quarters_path
    within '.managed-resource-list' do
      el = page.find('.managed-resource-list__name', text: quarter.name).ancestor('li')

      within el do
        click_on 'Edit'
      end
    end

    fill_in 'Quarter name', with: updated_name
    choose 'No'

    click_on 'Save'

    within '.managed-resource-list' do
      expect(page).to have_content(updated_name)
    end

    record = Quarter.last
    expect(record.name).to eq(updated_name)
    expect(record).to_not be_editable
  end
end
