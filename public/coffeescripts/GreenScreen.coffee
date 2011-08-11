GreenScreen = {
  timeout: 2000
  builds: []
  buildsURL: '/builds.json'
  
  init: ->
    @updateBuilds()
    setInterval($.proxy(@updateBuilds,@), @timeout)
  
  updateBuilds: ->
    $.getJSON @buildsURL, (builds)=>
      delete builds.unknown
      if @builds.length == 0
        @builds = builds
        @draw()
      else
        @builds = builds
        @draw()
        # @sort()
    
  clearBuilds: ->
    @builds = {}
    
  buildItem: (obj) ->
    item = $('<li>')
    item.text obj.name
    item.attr 'title', obj.last_build_time
    item.attr 'data-id', obj.name
    item.attr 'data-status', obj.last_build_status
    
  draw: ->
    $('ul').empty()
    $.each @builds, (category,projects)=>
      $("##{category} h1 .count").text projects.length
      $.each projects, (index,project)=>
        $("##{category} ul").append @buildItem(project)
}

window['GreenScreen'] = GreenScreen

$ ->
  GreenScreen.init()