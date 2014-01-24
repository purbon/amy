class Tabelle

  constructor: ->
    return

  setup: (url) ->
   self = this
   request_config =
       url: url+"?date="+(new Date()).getTime()
       type: "GET"
       dataType: "json"
       success: (data) ->
          $('.resources div').remove()
          i = 0
          for resource,config of data['resources']
            resource = self.add_resource(resource, config, i, data['base_url'])
            resource.toggle()
            i++
          self.add_resource_events(data)
          self.toggle_method_if_necessary()
       error: (e) ->
          $('.resources div').remove()
   $.ajax request_config
   return

  add_resource: (name, resource, i, base_url="") ->
      resource = new Resource(name, resource, i, base_url)
      resource.build()
      return resource

  add_resource_events: (data) ->
      handlerIn = () ->
        $(this).css("background", "#f5f5f5")
        $(this).children('div').children().css('color', 'black')
        return
      handlerOut = () ->
        $(this).css("background", "#fff")
        $(this).children('div').children().css('color', '#999')
        return
      $(".resource").hover(handlerIn, handlerOut)
      $('.resource').click ->
        event.stopPropagation()
        $(this).next().fadeToggle()
        return
      return

  toggle_method_if_necessary: -> 
      anchor = window.location.hash.replace('!','')
      anchor = anchor.replace(/\//g,"\\/")
      anchor = anchor.replace(/:/g,'\\:')
      fields = anchor.split('#')
      $("#"+fields[1]+" + div .method."+fields[2]+" .content").fadeToggle()
      $("#"+fields[1]+" + div .method."+fields[2]+" .form").fadeToggle()
      $("#"+fields[1]).next().fadeToggle()
      return

  @toggleMethods: (i) ->
      event.stopPropagation()
      $("#resource#{i}").fadeToggle()
      return
  @showJSON: ->
      event.stopPropagation()
      url = $("#selector #key").val()
      window.open(url, "_self") if url
      return

  window.toggleMethods = Tabelle.toggleMethods
  window.showJSON      = Tabelle.showJSON

$(document).ready ->
 tabelle = new Tabelle
 utils   = new Utils
 utils.toggle_by_class 'content'
 url = utils.default_config_url()
 $('#header #selector input').val(url)
 tabelle.setup(url)
 $('#header #explore').click ->
   tabelle.setup($('#header #selector input').val())
 return
