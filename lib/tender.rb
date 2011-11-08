require 'net/http'
require 'yaml'
require 'json'
require 'crack'


class Tender
  BASE = "http://api.tenderapp.com"

  def self.stats
    config = (YAML.load_file 'config.yml')[0]
    sub_domain = config["tender"]["sub_domain"]
    key = config["tender"]["key"]
    domain = "#{Tender::BASE}/#{sub_domain}"

    puts "#{key} / #{domain}"

    pending_count = self.pending(domain, key)
    queue_array = self.queues(domain, key)
    queue_array.push({:name=>"Pending", :current=>0, :recent=>pending_count, :closed=>0})
    queue_array
  end

  def self.pending(domain, key)
    uri = URI.parse("#{domain}/discussions/pending")
    puts uri
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"Accept" => "application/vnd.tender-v1+json", "X-Tender-Auth" => key})
    response = http.request(request)    
    unless response.body.nil?
      p = Crack::JSON.parse(response.body)
      discussions = p["discussions"]
      discussions.select {|d| d["cached_queue_list"].empty?}.count
    else
      0
    end    
  end

  def self.queues(domain, key)
    uri = URI.parse("#{domain}/queues")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"Accept" => "application/vnd.tender-v1+json", "X-Tender-Auth" => key})
    response = http.request(request)    
    puts "-----------"
    puts response.body
    unless response.body.nil?
      p = Crack::JSON.parse(response.body)
      named_queues = p["named_queues"]
      queue_list = []
      named_queues.each do |q|
        queue_list.push({:name=>q["name"], :current=>q["open_discussions_count"], :recent => q["new_discussions_count"], :closed => q["resolved_discussions_count"]})
      end
    else
      queue_list = []
    end    
    queue_list
  end
end