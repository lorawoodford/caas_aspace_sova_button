# frozen_string_literal: true

require_relative '../../../../frontend/spec/selenium/spec_helper'

describe 'Resources and archival objects' do
  before(:all) do
    @repo = create(:repo, repo_code: "caas_aspace_sova_button_test_#{Time.now.to_i}")
    set_repo @repo

    @user = create_user(@repo => ['repository-managers'])
    @driver = Driver.get.login_to_repo(@user, @repo)

    @driver.find_element(:link, 'System').click
    @driver.wait_for_dropdown
    @driver.click_and_wait_until_gone(:link, 'Manage Controlled Value Lists')

    sleep(0.5)
    enum_select = @driver.find_element(id: 'enum_selector')
    enum_select.select_option_with_text('Resource Finding Aid Status (resource_finding_aid_status)')

    @driver.find_element(:link, 'Create Value').click
    @driver.clear_and_send_keys([:id, 'enumeration_value_'], 'published')

    @driver.click_and_wait_until_gone(:css, '.modal-footer .btn-primary')
    run_index_round

    @resource = create(:resource,
                       ead_id: 'USA.123')

    @archival_object = create(:archival_object,
                              resource: { 'ref' => @resource.uri })
  end

  before(:each) do
    @driver.go_home
  end

  after(:all) do
    @driver ? @driver.quit : next
  end

  it 'can create a resource' do
    @driver.get_edit_page(@resource)

    expect(@driver.find_elements(:link, 'View in SOVA').length).to eq(0)

    finding_aid_data = @driver.find_element(xpath: '//select[contains(@id, "resource_finding_aid_status_")]')
    finding_aid_data.select_option_with_text('published')
    binding.pry
    @driver.wait_for_dropdown
    @driver.find_elements(:link, 'Browse')[1].click

    @driver.find_element(:button, 'View in SOVA').click
  end
end
