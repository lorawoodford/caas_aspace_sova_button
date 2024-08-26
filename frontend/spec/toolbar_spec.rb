# frozen_string_literal: true

require "#{ASUtils.find_base_directory}/frontend/spec/spec_helper"
require "#{ASUtils.find_base_directory}/frontend/spec/rails_helper"

def add_enum
  visit "resources/#{@published_resource.id}/edit"
  already_set = find('#resource_finding_aid_status_').value == 'publish'
  unless already_set
    click_on 'System'
    click_on 'Manage Controlled Value Lists'

    select 'Resource Finding Aid Status (resource_finding_aid_status)', from: 'List Name'

    element = find('a', text: 'Create Value')
    element.click

    within '#form_enumeration' do
      fill_in 'enumeration_value_', with: 'publish'
      click_on 'Create Value'
    end

    element = find('.alert.alert-success.with-hide-alert')
    expect(element.text).to eq 'Value Created'
    expect(page).to have_css 'tr', text: 'publish'

    run_index_round

    visit "resources/#{@published_resource.id}/edit"
    select 'publish', from: 'Finding Aid Status'
    within '#archivesSpaceSidebar' do
      click_on 'Save Resource'
    end

    wait_for_ajax
  end
end

describe 'View in SOVA toolbar button', js: true do
  before(:all) do
    @repository = create(:repo, repo_code: "caas_aspace_sova_button_test_#{Time.now.to_i}")

    set_repo @repository

    @resource = create(:resource, title: "Unpublished Resource", ead_id: 'USA.123')
    @published_resource = create(:resource, title: "Published Resource", ead_id: 'USA.456')
    @unpublished_ao = create(:archival_object, title: "Archival Object Unpublished Resource", resource: { ref: @resource.uri })
    @published_ao = create(:archival_object, title: "Archival Object Published Resource", resource: { ref: @published_resource.uri })

    run_index_round
  end

  before(:each) do
    login_admin
    select_repository(@repository)
  end

  context 'when finding aid status is not publish' do
    it 'does not show the button on the resource' do
      visit "resources/#{@resource.id}"
      wait_for_ajax

      expect(page).not_to have_text 'View in SOVA'
    end

    it 'does not show the button on a child archival object' do
      visit "resources/#{@resource.id}/edit#tree::archival_object_#{@unpublished_ao.id}"

      wait_for_ajax

      expect(page).not_to have_text 'View in SOVA'
    end
  end

  context 'when finding aid status is publish' do
    before(:each) do
      add_enum
    end

    it 'shows the button with correct sova link on the resource' do
      visit "resources/#{@published_resource.id}/edit"

      expect(page).to have_text 'View in SOVA'

      button = find(:xpath, '//a[text()="View in SOVA"]')
      expect(button[:href]).to match('https://sova.si.edu/record/usa.456')
    end

    it 'shows the button with correct sova link on a child archival object' do
      visit "resources/#{@published_resource.id}/edit#tree::archival_object_#{@published_ao.id}"

      wait_for_ajax

      expect(page).to have_text 'View in SOVA'

      button = find(:xpath, '//a[text()="View in SOVA"]')
      expect(button[:href]).to start_with('https://sova.si.edu/record/')
    end
  end
end
