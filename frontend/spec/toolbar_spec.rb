# frozen_string_literal: true

require_relative '../../../../frontend/spec/spec_helper'
require_relative '../../../../frontend/spec/rails_helper'

describe 'View in SOVA toolbar button', js: true do
  before(:all) do
    @admin = BackendClientMethods::ASpaceUser.new('admin', 'admin')
    @repository = create(:repo, repo_code: "caas_aspace_sova_button_test_#{Time.now.to_i}")

    set_repo @repository

    @resource = create(:resource, title: "Unpublished Resource", ead_id: 'USA.123')
    @published_resource = create(:resource, title: "Published Resource", ead_id: 'USA.456')
    @unpublished_ao = create(:archival_object, title: "Archival Object Unpublished Resource", resource: { ref: @resource.uri })
    @published_ao = create(:archival_object, title: "Archival Object Published Resource", resource: { ref: @published_resource.uri })

    run_index_round
  end

  before(:each) do
    login_user(@admin)
    select_repository(@repository)
  end

  context 'when I have my custom controlled value set' do
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
      it 'shows the button with correct sova link on the resource' do
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

        expect(page).to have_text 'View in SOVA'

        button = find(:xpath, '//a[text()="View in SOVA"]')
        expect(button[:href]).to match('https://sova.si.edu/record/usa.456')
      end

      it 'shows the button with correct sova link on a child archival object' do
        visit "resources/#{@published_resource.id}/edit#tree::archival_object_#{@published_ao.id}"

        wait_for_ajax

        expect(page).to have_text 'View in SOVA'

        button = find(:xpath, '//a[text()="View in SOVA"]')
        # If using the ref_id plugin we can predict the full url, if not, we can't
        if AppConfig[:plugins].include?('caas_aspace_refid')
          expect(button[:href]).to match('https://sova.si.edu/record/usa.456/ref1')
        else
          expect(button[:href]).to start_with('https://sova.si.edu/record/')
        end
      end
    end
  end


  # context 'when finding aid status is not publish' do
  #   it 'does not show the button on the resource' do
  #     @driver.get_edit_page(@resource)

  #     expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(0)
  #   end

  #   it 'does not show the button on a child archival object' do
  #     @driver.get_edit_page(@resource)

  #     # Create archival object
  #     @driver.find_element(:link, 'Add Child').click
  #     @driver.clear_and_send_keys([:id, 'archival_object_title_'], 'New archival object')
  #     @driver.find_element(:id, 'archival_object_level_').select_option('item')
  #     @driver.click_and_wait_until_gone(css: "form#archival_object_form button[type='submit']")

  #     expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(0)
  #   end
  # end

  # context 'when finding aid status is publish' do
  #   before do
  #     @driver.get_edit_page(@resource)

  #     finding_aid_data = @driver.find_element(xpath: '//select[contains(@id, "resource_finding_aid_status_")]')
  #     finding_aid_data.select_option_with_text('publish')
  #     @driver.click_and_wait_until_gone(css: "form#resource_form button[type='submit']")
  #   end

  #   it 'shows the button with correct sova link on the resource' do
  #     @driver.get_edit_page(@resource)
  #     @driver.wait_for_ajax

  #     expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(1)
  #     expect(@driver.find_element(:link, 'View in SOVA').attribute('href')).to match('https://sova.si.edu/record/usa.123')
  #   end

  #   it 'shows the button with correct sova link on a child archival object' do
  #     @driver.get_edit_page(@resource)
  #     @driver.find_element(:link, 'New archival object').click

  #     expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(1)

  #     # If using the ref_id plugin we can predict the full url, if not, we can't
  #     if AppConfig[:plugins].include?('caas_aspace_refid')
  #       expect(@driver.find_element(:link, 'View in SOVA').attribute('href')).to match('https://sova.si.edu/record/usa.123/ref1')
  #     else
  #       expect(@driver.find_element(:link, 'View in SOVA').attribute('href')).to start_with('https://sova.si.edu/record/')
  #     end
  #   end
  # end
end
