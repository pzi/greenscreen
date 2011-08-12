require 'rexml/document'
require 'hpricot'
require 'open-uri'

module Greenscreen  
  def self.servers
    servers = YAML.load_file 'config.yml'
    raise StandardError.new("Add the details of build server to the config.yml file to get started") unless servers
    servers
  end
  
  def self.projects
    collection = Hash.new
    servers.each do |server|
      xml = REXML::Document.new open(server['url'], :http_basic_authentication => [server['username'], server['password']])
      projects = xml.elements['//Projects']
      projects.each do |project|
        project = MonitoredProject.new(project)
        collection[project.status] = Array.new if collection[project.status].nil?
        collection[project.status] << project.inspect
      end
    end
    collection
  end
end
