module ToolbarHelper
  SOVA_URN = "sova.si.edu"

  def self.sova_link_from_record(record_id, record_type)
    path = record_id.downcase
    if record_type == 'archival_object'
      path.gsub!('_', '/')
    end

    File.join('/record/',
              path)
  end
end
