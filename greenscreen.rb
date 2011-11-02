require "rubygems"
require "bundler/setup"

require 'sinatra'
require 'erb'

$:.push File.expand_path(File.join(__FILE__, '..'))

require 'lib/monitored_project'
require 'lib/greenscreen'
require 'lib/tender'

helpers do
  def partial(page, options={})
    erb page, options.merge!(:layout => false)
  end
end

before do
  @projects = Greenscreen.projects

  @columns = 1.0
  @columns = 2.0 if @projects.size > 4
  @columns = 3.0 if @projects.size > 10
  @columns = 4.0 if @projects.size > 21

  @rows = (@projects.size / @columns).ceil


  
end

get '/' do
  @tender_stats = Tender.stats
  erb :index
end

get '/builds' do
  erb :builds
end
