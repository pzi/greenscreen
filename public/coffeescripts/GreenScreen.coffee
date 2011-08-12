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
        @refresh()
    
  clearBuilds: ->
    @builds = {}
    
  buildItem: (obj) ->
    item = $('<li>')
    item.text obj.name
    item.attr 'title', obj.last_build_time
    item.attr 'data-id', obj.name
    item.attr 'data-status', obj.status
    
  draw: ->
    $('ul').empty()
    $.each @builds, (category,projects)=>
      $("##{category} h1 .count").text projects.length
      $.each projects, (index,project)=>
        $("##{category} ul").append @buildItem(project)
        
  refresh: ->
    $.each @builds, (category,projects)=>
      $.each projects, (index,project)=>
        currentBuild = $("li[data-id='#{project.name}']")
        newBuild = @buildItem(project)
        unless currentBuild.attr('data-status') == newBuild.attr('data-status')
          currentBuild.fadeOut 500, =>
            currentBuild.remove()
            newBuild.hide()
            $("##{category} ul").append newBuild
            newBuild.fadeIn 500
            @updateCounts()
            
  updateCounts: ->
    $('ul').each ->
      list = $(@)
      count = list.find('li').length
      header = list.siblings('h1:first').find('.count')
      header.text(count)
}

window['GreenScreen'] = GreenScreen

$ ->
  GreenScreen.init()