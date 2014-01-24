class Resource

   constructor: (resource, config, i, base_url) ->
     @resource = resource
     @config   = config
     @i        = i
     @base_url = base_url
     return
  
   toggle: ->
     $("#resource#{@i}").toggle()
     return

   build: ->
     html = this.build_html(@resource, @config, @i)
     $('.resources').append(html)
     for method, data of @config['config']
         runner = new MethodRunner(method, @config['config'], @base_url, @i)
         runner.attach_to_form()

     $("#resource#{@i} .content").toggle()
     $("#resource#{@i} .form").toggle()
     $("#resource#{@i} .method .url a").click (event) -> 
       $(this).parent().parent().next().next().fadeToggle()
       $(this).parent().parent().next().fadeToggle()
     return

   build_html: (resource, config, i) ->
     html  = "<div class='resource' id='#{resource}'>"
     html += "<div class='name'>  <a href='#!#{resource}'>#{resource}</a> </div>"
     html += "<div class='title'>#{config['title']}</div>"
     html += "<div class='menu'> <a href='#' onclick='toggleMethods(#{i})'>Show/Hide</a> | <a href='#' onclick='showJSON()'>Raw</a> </div>"
     html += '</div>'
     html += this.add_section(resource, config['config'], config['config'], i)
     return html
   
   add_section: (resource, config, entries, i) ->
     html  = "<div class='methods' id='resource#{i}'>"
     for method, field of config
        method_name = method.replace(/(\d+)/g,'')
        content = entries[method.toLowerCase()]['content']
        html += "<div class='method #{method_name}'>"
        html += '<div class="header">'
        html += "<div class='name #{method_name}'>#{method_name}</div>"
        html += "<div class='url'><a href='#!#{resource}##{method.toLowerCase()}'>#{field['url']}</a></div>"
        html += "<div class='desc'>#{field['title']}</div>"
        html += '</div>'
        html += "<div class='form'>#{this.add_form(method.toLowerCase(), entries[method.toLowerCase()])}</div>"
        html += "<div class='content'>#{content}</div>"
        html += "</div>"
     html += '</div>'
     return html
  
   add_form: (method, config) ->
     form = new ResourceForm(method, config)
     return form.build()

