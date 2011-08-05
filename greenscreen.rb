require "rubygems"
require "bundler/setup"

require 'sinatra'
require 'erb'

require 'lib/monitored_project'
require 'lib/greenscreen'

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
  erb :index
end

get '/partial' do
  erb :builds
end
