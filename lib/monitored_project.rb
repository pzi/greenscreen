class MonitoredProject

  attr_accessor :name, :last_build_status, :activity, :last_build_time, :web_url, :last_build_label

  def initialize(project)
    @activity = project.attributes["activity"]
    @last_build_time = Time.parse(project.attributes["lastBuildTime"]).localtime
    @web_url = project.attributes["webUrl"]
    @last_build_label = project.attributes["lastBuildLabel"]
    @last_build_status = project.attributes["lastBuildStatus"].downcase
    @name = project.attributes["name"]
  end
  
  def attributes
    {
      :name => @name,
      :web_url => @web_url,
      :activitiy => @activity,
      :last_build_label => @last_build_label,
      :last_build_status => @last_build_status,
      :last_build_time => @last_build_time
    }
  end

end
