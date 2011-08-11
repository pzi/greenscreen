GreenScreen = {
  timeout: 5000
  builds: {}
  buildsURL: '/builds'
  buildsContainerSelector: '#builds'
  buildsSelector: '.project'
  buildTimeSelector: 'span.build_time'
  playSounds: false
  
  init: ->
    $.setInterval updateBuilds, timeout
  
  updateBuilds: ->
    $.get(buildsURL, draw)
    
  drawBuilds: (html)->
    builds = $(html)
    builds.find(buildTimeSelector).timeago()
    $(buildsContainerSelector).html builds
    checkBuildStatus()
    
  clearBuilds: ->
    @builds = {}
    
  checkStatus: ->
    success = false
    failure = false
    $(buildsSelector).each (index, element) ->
      element = $(element)
      name = element.attr 'data-name'
      status = element.attr 'data-status'
    
  enableSounds: ->
    @playSounds = true
    
  disableSounds: ->
    @playSounds = false
}

GreenScreen.Build = {
  init: ->
    @name = 
  init()
}

window['GreenScreen'] = GreenScreen

$ ->
  GreenScreen.init()