@magicmockup = do ->
  layers = {}
  filter = {}
  defaultLayer = ''
  doc = null

  # Helper function for converting a live collection to a static array
  _toArray = (collection) ->
    [].slice.call(collection)

  # Helper function for converting a string css time interval (in s) to milliseconds
  _toMS = (time) ->
    parseFloat(time) * 1000

  # Convenience function to grab attributes from the Inkscape namespace
  _getInk = (el, attr) ->
    inkNS = 'http://www.inkscape.org/namespaces/inkscape'
    el.getAttributeNS(inkNS, attr)


  # Add each layer to the layer object (if it contains a an Inkscape label)
  _initLayers = () ->
    groups = _toArray(document.getElementsByTagName 'g')
    for group in groups
      mode = _getInk group, 'groupmode'

      if mode is 'layer'
        label = _getInk group, 'label'
        layers[label] =  group

    return

  # Helper function to handle acting on `both layers and
  # arbitrary objects
  _fetch = (id) ->
    if layers[id]?
      layers[id]
    else
      document.getElementById(id)

  # Find all filters and store in the filter object
  _findFilters = ->
    filters = _toArray(document.getElementsByTagName 'filter')

    for f in filters
      label = _getInk f, 'label'
      filter[label] = f.id

  # Utility functions to manipulate object visibility
  _hide = (id) ->
    _fetch(id).style.display = 'none'

  _show = (id) ->
    _fetch(id).style.display = 'block'

  _hidden = (id) ->
    _fetch(id).style.display == 'none'

  # Animation functions
  _fade = (id, duration) ->
    el = _fetch(id)
    el.setAttribute "style", "transition: " + duration + " opacity; opacity: 0"
    setTimeout ->
      el.style.display = 'none'
    , _toMS(duration)
    return

  # Do the heavy lifting
  _dispatch = (command, val) ->
    act =
      load: (url) ->
        url = url.shift()
        window.location = url || val

      next: (location) ->
        location = location.shift()
        if location.match /#/
          # if "#" is added, then load the new page
          act.load(location)

        else
          for layer in layers
            unless layer.style.display is 'none'
              layer.style.display = 'none'
          # Show the specified layer
          _show(location)

          window.location.hash = location

      show: (show) ->
        for id in show
          _show(id)

      hide: (hide) ->
        for id in hide
          _hide(id)

      toggle: (toggle) ->
        for id in toggle
          if _hidden(id)
            _show(id)
          else
            _hide(id)

      fadeOut: (params) ->
        console.log 'fadeing', params
        duration = params[1] || ".5s"
        console.log 'duration', duration
        _fade params[0], duration

    params = val?.split ','
    params = (p.trim() for p in params)
    act[command]?(params)

  # Return the description for an element
  _getDescription = (el) ->
    (el.getElementsByTagName 'desc')[0].textContent

  _hasDescription = (el) ->
    (el.getElementsByTagName 'desc').length > 0

  # If there's inline JS, strip it (and provide warnings)
  _stripInlineJS = ->
    onclickElements = document.querySelector "[onclick]"

    return unless onclickElements?.length

    # Warn about inline JS (if console.warn is available)
    if console and console.warn

      console.group? 'Warning: inline JavaScript found (and deactivated)'
      for el in onclickElements
        console.warn el.id, ":", el.onclick
      console.groupEnd?()

    # Strip the inline JS
    for el in onclickElements
      el.onclick = undefined

    return


  # Return the URL fragment
  _getHash = ->
    window.location.hash.substr 1


  # Hide all top-level groups
  _hideGroups = ->
    g = _toArray(document.getElementsByTagName 'g')
    for el in g
      el.style.display = "none"

  # Make a group visible
  _showGroup = (group) ->
    if typeof group isnt 'string'
      group = _getHash()

    # Make sure the group exists
    g = document.getElementById group
    if g?
      _hideGroups()
      _dispatch @, ['next', group]

    return

  # If a hash is specified, view the appropriate group
  _setInitialPage = ->
    group = _getHash()

    if group
      _showGroup group

  # Handle clicks on items with instructions
  _handleClick = (e) ->
    actions = _getDescription(e.currentTarget)

    # Skip if there's no description
    return unless actions

    for action in actions.split /\n/
      actionArr = action.split /\=/
      _dispatch actionArr[0], actionArr[1]

    return

  # Change the cursor for interactive elements
  _handleHover = (e) ->
    el = e.currentTarget

    # Skip if there's no description
    if _getDescription(el)

      # Alter hover CSS if there's a hover filter
      if filter.hover
        el.style.filter="url(##{filter.hover})"

      # Skip if already hoverable
      unless el.hoverable == true
        # We're handling the hoverable state now
        el.hoverable = true
        el.style.cursor = "pointer"

    return


  # This function binds the correct events to trigger elements.
  # Trigger elements are any element with a 'desc' child element.
  # If new trigger elements will be added to the SVG DOM,
  # this function should be called afterwards to
  # ensure they are correctly bound.
  bindTriggers = () ->
    descs = _toArray(document.getElementsByTagName 'desc')
    for el in descs
      el.parentElement.addEventListener 'click', _handleClick
      el.parentElement.addEventListener 'mouseover', _handleHover

  # Run on page load
  init = () ->
    _initLayers()
    _setInitialPage()
    _findFilters()
    _stripInlineJS()

    window.addEventListener 'hashchange', _showGroup
    bindTriggers()

  {init, bindTriggers} # Public exports

window.onload = () ->
  magicmockup.init()
