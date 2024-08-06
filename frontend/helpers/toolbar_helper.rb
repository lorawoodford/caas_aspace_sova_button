module ToolbarHelper
  def self.sova_link_from_resource(record)
    identifier = [record[:id_0], record[:id_1], record[:id_2], record[:id_3]].compact.join(".").downcase
    URI.join(
      "https:://sova.si.edu/#{identifier}"
    ).to_s
  end
end
