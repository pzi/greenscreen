require "rubygems"
require "bundler/setup"

require 'sinatra'
require 'sinatra/respond_to'

require 'lib/monitored_project'
require 'lib/greenscreen'

require 'haml'
require 'json'

Sinatra::Application.register Sinatra::RespondTo

helpers do
  def partial(page, options={})
    haml page, options.merge!(:layout => false)
  end
end

get '/' do
  haml :index
end

get '/builds' do
  @projects = Greenscreen.projects
  respond_to do |wants|
    wants.html { haml :builds }
    wants.json { @projects.map(&:attributes).to_json }
  end
end
