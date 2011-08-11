GreenScreen = {
  timeout: 5000
  builds: []
  buildsURL: '/builds.json'
  buildsContainerSelector: '#builds'
  buildsSelector: '.build'
  buildTimeSelector: 'span.build_time'
  playSounds: false
  templatesURL: '/templates.json'
  
  init: ->
    @updateBuilds()
    setInterval @updateBuilds(), 500
  
  updateBuilds: ->
    $.getJSON @buildsURL, (builds)=>
      @builds = builds
      @draw()
    
  clearBuilds: ->
    @builds = {}
    
  draw: ->
    $('ul').empty()
    $.each @builds, (index,build) ->
      # html = $(ich.build(build))
      # html.find('p').timeago()
      # container.append html
    @resize()
    
  resize: ->
    windowHeight = window.innerHeight
    rows = Math.ceil @builds.length / 4
    height = Math.ceil windowHeight / rows
    $(@buildsSelector).height(height)
      
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

window['GreenScreen'] = GreenScreen

$ ->
  GreenScreen.init()
  $(window).resize ->
    GreenScreen.resize()