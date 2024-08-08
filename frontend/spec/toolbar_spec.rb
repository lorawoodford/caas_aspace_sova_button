# frozen_string_literal: true

require_relative '../../../../frontend/spec/selenium/spec_helper'

describe 'View in SOVA toolbar button' do
  before(:all) do
    @repo = create(:repo, repo_code: "caas_aspace_sova_button_test_#{Time.now.to_i}")
    set_repo @repo

    @user = create_user(@repo => ['repository-managers'])
    @driver = Driver.get.login_to_repo(@user, @repo)

    # We've got to add our custome finding aid status enum
    @driver.find_element(:link, 'System').click
    @driver.wait_for_dropdown
    @driver.click_and_wait_until_gone(:link, 'Manage Controlled Value Lists')
    sleep(0.5)
    enum_select = @driver.find_element(id: 'enum_selector')
    enum_select.select_option_with_text('Resource Finding Aid Status (resource_finding_aid_status)')
    @driver.find_element(:link, 'Create Value').click
    @driver.clear_and_send_keys([:id, 'enumeration_value_'], 'publish')
    @driver.click_and_wait_until_gone(:css, '.modal-footer .btn-primary')
    run_index_round

    @resource = create(:resource,
                       ead_id: 'USA.123')
    # @archival_object = create(:archival_object,
    #                           resource: { 'ref' => @resource.uri })
  end

  before(:each) do
    @driver.go_home
  end

  after(:all) do
    @driver ? @driver.quit : next
  end

  context 'when finding aid status is not publish' do
    it 'does not show the button on the resource' do
      @driver.get_edit_page(@resource)

      expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(0)
    end

    it 'does not show the button on a child archival object' do
      @driver.get_edit_page(@resource)

      # Create archival object
      @driver.find_element(:link, 'Add Child').click
      @driver.clear_and_send_keys([:id, 'archival_object_title_'], 'New archival object')
      @driver.find_element(:id, 'archival_object_level_').select_option('item')
      @driver.click_and_wait_until_gone(css: "form#archival_object_form button[type='submit']")

      expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(0)
    end
  end

  context 'when finding aid status is publish' do
    before do
      @driver.get_edit_page(@resource)

      finding_aid_data = @driver.find_element(xpath: '//select[contains(@id, "resource_finding_aid_status_")]')
      finding_aid_data.select_option_with_text('publish')
      @driver.click_and_wait_until_gone(css: "form#resource_form button[type='submit']")
    end

    it 'shows the button with correct sova link on the resource' do
      @driver.get_edit_page(@resource)
      @driver.wait_for_ajax

      expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(1)
      expect(@driver.find_element(:link, 'View in SOVA').attribute('href')).to match('https://sova.si.edu/record/usa.123')
    end

    it 'shows the button with correct sova link on a child archival object' do
      @driver.get_edit_page(@resource)
      @driver.find_element(:link, 'New archival object').click

      expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(1)

      # If using the ref_id plugin we can predict the full url, if not, we can't
      if AppConfig[:plugins].include?('caas_aspace_refid')
        expect(@driver.find_element(:link, 'View in SOVA').attribute('href')).to match('https://sova.si.edu/record/usa.123/ref1')
      else
        expect(@driver.find_element(:link, 'View in SOVA').attribute('href')).to start_with('https://sova.si.edu/record/')
      end
    end
  end
end
