GreenScreen = {
  timeout: 2000
  builds: []
  buildsURL: '/builds.json'
  counts: { 'successes': 0, 'failures': 0, 'building': 0, 'total': 0 }
  sounds: {
    enabled: true
    success: new buzz.sound '/sounds/success', { formats: ['mp3','ogg','wav'] }
    failure: new buzz.sound '/sounds/fail', { formats: ['mp3','ogg','wav'] }
  }
  
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
      $.each projects, (index,project)=>
        $("##{category} ul").append @buildItem(project)
      @updateCounts()
      @checkForBuilding()
    
  getSuccesses:  ->
    $('#success ul li')
    
  getFailures: ->
    $('#failure ul li')
    
  getBuilding: ->
    $('#building ul li')
        
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
            if @sounds.enabled
              @playSounds()
            else
              @updateCounts()
            @checkForBuilding()
            
  checkForBuilding: ->
    header = $('#building h1')
    if @getBuilding.length > 0
      header.removeClass 'pulse'
    else
      header.addClass 'pulse'  
            
  updateCounts: ->
    $('ul').each ->
      list = $(@)
      count = list.find('li').length
      header = list.siblings('h1:first').find('.count')
      header.text(count)
    @counts.successes = @getSuccesses().length
    @counts.failures = @getFailures().length
    @counts.building = @getBuilding().length
    @counts.total = @counts.successes + @counts.failures + @counts.building
      
  playSounds: ->
    oldCounts = @counts
    @updateCounts()
    if oldCounts.total == @counts.total
      @sounds.success.play() if oldCounts.successes < @counts.successes
      @sounds.failures.play() if oldCounts.failures < @counts.failures
}

window['GreenScreen'] = GreenScreen

$ ->
  GreenScreen.init()