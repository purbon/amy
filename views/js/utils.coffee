class Utils

  constructor: ->
    return
    
  toggle_by_class: (clazz) ->
   elems = document.getElementsByClassName(clazz)
   for elem in elems
     console.log elem
     $(elem).toggle(false)
   return

  default_config_url: ->
   pn = window.location.pathname
   pn = pn.replace(pn.substring(pn.lastIndexOf('/')+1, pn.length), '')
   return "#{window.location.origin}#{pn}data.json"

