require 'nokogiri'
require 'open-uri'
require 'yaml'


module Greenscreen

  def self.servers
    servers = YAML.load_file 'config.yml'
    raise StandardError.new("Add the details of build server to the config.yml file to get started") unless servers

    servers
  end

  def self.projects
    collection = []

    servers.each do |server|

      doc = Nokogiri::XML(open(server["url"], :http_basic_authentication=>[server["username"], server["password"]]))

      doc.xpath("//Projects/Project").each do |project|
        monitored_project = MonitoredProject.new(project)
        if server["jobs"]
          if server["jobs"].detect { |job| job == monitored_project.name }
            collection << monitored_project
          end
        else
          collection << monitored_project
        end
      end
    end

    collection
  end

end
