class ResourceForm
   
   constructor: (method, config) ->
     @method = method
     @config = config
     return
   
   build: ->
     html = ''
     params = @config['params'] || []
     if @method in ["get", "options", "head"]
        html = this.add_form(params)
     return html
  
   add_form: (params) ->
     html = '<form>'
     for param in params
        html += "<div class='field'>"
        html += "<label>:#{params[0]}<small>(#{params[1]})</small></label>"
        html += "<input type='text' id='#{params[0]}'></input>"
        html += '</div>'
     html += '<input type="button" value="Submit"></input>'
     html += '</form>'
     html += '<textarea class="output"></textarea>'
     return html

class MethodRunner

   constructor: (method, config, base_url, i) ->
     @method   = method
     @config   = config
     @base_url = base_url
     @i        = i
     return

   attach_to_form: ->
     self = this
     $("#resource#{@i} .#{@method} .form input[type=button]").click (event) ->
        params      = self.scrap_params event
        outputField = $(event.target).parent().siblings('.output')
        config      = self.config[self.method]
        self.execute_method(self.method.toUpperCase(), self.base_url, config, params, outputField)
     return

   scrap_params: (event) ->
     oid = $(event.target).parentsUntil(".methods")
     oid = $($(oid)[oid.length-1]).parent().prev().attr('id')
     fields = $(event.target).parent().children('.field').children('input')
     params = {}
     $.each fields, (i, n) ->
       params[$(n).attr('id')] = $(n).val()
       return
     return params

   execute_method: (method, base_url, config, params, output) ->
     url  = "#{base_url}#{config['url']}"
     for oid, param of params
       url  = url.replace(':'+oid, param)
     ajax_call =
       type: method
       async: true
       url: url
       success: (data) ->
          output.text(JSON.stringify(data))
          return
     $.ajax ajax_call
     return

   
