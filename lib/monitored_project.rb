class MonitoredProject

  attr_accessor :name, :last_build_status, :activity, :last_build_time, :web_url, :last_build_label

  def initialize(project)
    @activity = project["activity"]
    @last_build_time = Time.parse(project["lastBuildTime"]).localtime
    @web_url = project["webUrl"]
    @last_build_label = project["lastBuildLabel"]
    @last_build_status = project["lastBuildStatus"].downcase
    @name = project["name"]
  end

end
