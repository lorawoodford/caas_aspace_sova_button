module ToolbarHelper
  SOVA_PROD_DOMAIN = 'sova.si.edu'
  SOVA_TEST_DOMAIN = 'sova-test.si.edu'

  def self.sova_link_from_record(record_id, record_type)
    path = record_id.downcase
    if record_type == 'archival_object'
      path.gsub!('_', '/')
    end

    File.join('/record/',
              path)
  end

  def self.sova_base_domain(host)
    if host.exclude?('test')
      SOVA_PROD_DOMAIN
    else
      SOVA_TEST_DOMAIN
    end
  end
end
