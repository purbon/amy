// Generated by CoffeeScript 1.6.3
(function() {
  var MethodRunner, Resource, ResourceForm, Tabelle, Utils;

  Tabelle = (function() {
    function Tabelle() {
      return;
    }

    Tabelle.prototype.setup = function(url) {
      var request_config, self;
      self = this;
      request_config = {
        url: url + "?date=" + (new Date()).getTime(),
        type: "GET",
        dataType: "json",
        success: function(data) {
          var config, i, resource, _ref;
          $('.resources div').remove();
          i = 0;
          _ref = data['resources'];
          for (resource in _ref) {
            config = _ref[resource];
            resource = self.add_resource(resource, config, i, data['base_url']);
            resource.toggle();
            i++;
          }
          self.add_resource_events(data);
          return self.toggle_method_if_necessary();
        },
        error: function(e) {
          return $('.resources div').remove();
        }
      };
      $.ajax(request_config);
    };

    Tabelle.prototype.add_resource = function(name, resource, i, base_url) {
      if (base_url == null) {
        base_url = "";
      }
      resource = new Resource(name, resource, i, base_url);
      resource.build();
      return resource;
    };

    Tabelle.prototype.add_resource_events = function(data) {
      var handlerIn, handlerOut;
      handlerIn = function() {
        $(this).css("background", "#f5f5f5");
        $(this).children('div').children().css('color', 'black');
      };
      handlerOut = function() {
        $(this).css("background", "#fff");
        $(this).children('div').children().css('color', '#999');
      };
      $(".resource").hover(handlerIn, handlerOut);
      $('.resource').click(function() {
        event.stopPropagation();
        $(this).next().fadeToggle();
      });
    };

    Tabelle.prototype.toggle_method_if_necessary = function() {
      var anchor, fields;
      anchor = window.location.hash.replace('!', '');
      anchor = anchor.replace(/\//g, "\\/");
      anchor = anchor.replace(/:/g, '\\:');
      fields = anchor.split('#');
      $("#" + fields[1] + " + div .method." + fields[2] + " .content").fadeToggle();
      $("#" + fields[1] + " + div .method." + fields[2] + " .form").fadeToggle();
      $("#" + fields[1]).next().fadeToggle();
    };

    Tabelle.toggleMethods = function(i) {
      event.stopPropagation();
      $("#resource" + i).fadeToggle();
    };

    Tabelle.showJSON = function() {
      var url;
      event.stopPropagation();
      url = $("#selector #key").val();
      if (url) {
        window.open(url, "_self");
      }
    };

    window.toggleMethods = Tabelle.toggleMethods;

    window.showJSON = Tabelle.showJSON;

    return Tabelle;

  })();

  $(document).ready(function() {
    var tabelle, url, utils;
    tabelle = new Tabelle;
    utils = new Utils;
    utils.toggle_by_class('content');
    url = utils.default_config_url();
    $('#header #selector input').val(url);
    tabelle.setup(url);
    $('#header #explore').click(function() {
      return tabelle.setup($('#header #selector input').val());
    });
  });

  ResourceForm = (function() {
    function ResourceForm(method, config) {
      this.method = method.replace(/[0-9]/g, '');
      this.config = config;
      return;
    }

    ResourceForm.prototype.build = function() {
      var html, params, _ref;
      html = '';
      params = this.config['params'] || [];
      if ((_ref = this.method) === "get" || _ref === "options" || _ref === "head") {
        html = this.add_form(params);
      }
      return html;
    };

    ResourceForm.prototype.add_form = function(params) {
      var html, param, _i, _len;
      html = '<form>';
      for (_i = 0, _len = params.length; _i < _len; _i++) {
        param = params[_i];
        html += "<div class='field'>";
        html += "<label>:" + param[0] + "<small>(" + param[1] + ")</small></label>";
        html += "<input type='text' id='" + param[0] + "'></input>";
        html += '</div>';
      }
      html += '<input type="button" value="Submit"></input>';
      html += '</form>';
      html += '<textarea class="output"></textarea>';
      return html;
    };

    return ResourceForm;

  })();

  MethodRunner = (function() {
    function MethodRunner(method, config, base_url, i) {
      this.method = method;
      this.config = config;
      this.base_url = base_url;
      this.i = i;
      return;
    }

    MethodRunner.prototype.attach_to_form = function() {
      var self;
      self = this;
      $("#resource" + this.i + " ." + this.method + " .form input[type=button]").click(function(event) {
        var config, outputField, params;
        params = self.scrap_params(event);
        outputField = $(event.target).parent().siblings('.output');
        config = self.config[self.method];
        return self.execute_method(self.method.toUpperCase(), self.base_url, config, params, outputField);
      });
    };

    MethodRunner.prototype.scrap_params = function(event) {
      var fields, oid, params;
      oid = $(event.target).parentsUntil(".methods");
      oid = $($(oid)[oid.length - 1]).parent().prev().attr('id');
      fields = $(event.target).parent().children('.field').children('input');
      params = {};
      $.each(fields, function(i, n) {
        params[$(n).attr('id')] = $(n).val();
      });
      return params;
    };

    MethodRunner.prototype.execute_method = function(method, base_url, config, params, output) {
      var ajax_call, oid, param, url;
      url = "" + base_url + config['url'];
      for (oid in params) {
        param = params[oid];
        url = url.replace(':' + oid, param);
      }
      ajax_call = {
        type: method,
        async: true,
        url: url,
        success: function(data) {
          output.text(JSON.stringify(data));
        }
      };
      $.ajax(ajax_call);
    };

    return MethodRunner;

  })();

  Resource = (function() {
    function Resource(resource, config, i, base_url) {
      this.resource = resource;
      this.config = config;
      this.i = i;
      this.base_url = base_url;
      return;
    }

    Resource.prototype.toggle = function() {
      $("#resource" + this.i).toggle();
    };

    Resource.prototype.build = function() {
      var data, html, method, runner, _ref;
      html = this.build_html(this.resource, this.config, this.i);
      $('.resources').append(html);
      _ref = this.config['config'];
      for (method in _ref) {
        data = _ref[method];
        runner = new MethodRunner(method, this.config['config'], this.base_url, this.i);
        runner.attach_to_form();
      }
      $("#resource" + this.i + " .content").toggle();
      $("#resource" + this.i + " .form").toggle();
      $("#resource" + this.i + " .method .url a").click(function(event) {
        $(this).parent().parent().next().next().fadeToggle();
        return $(this).parent().parent().next().fadeToggle();
      });
    };

    Resource.prototype.build_html = function(resource, config, i) {
      var html;
      html = "<div class='resource' id='" + resource + "'>";
      html += "<div class='name'>  <a href='#!" + resource + "'>" + resource + "</a> </div>";
      html += "<div class='title'>" + config['title'] + "</div>";
      html += "<div class='menu'> <a href='#' onclick='toggleMethods(" + i + ")'>Show/Hide</a> | <a href='#' onclick='showJSON()'>Raw</a> </div>";
      html += '</div>';
      html += this.add_section(resource, config['config'], config['config'], i);
      return html;
    };

    Resource.prototype.add_section = function(resource, config, entries, i) {
      var content, field, html, method, method_name;
      html = "<div class='methods' id='resource" + i + "'>";
      for (method in config) {
        field = config[method];
        method_name = method.replace(/(\d+)/g, '');
        content = entries[method.toLowerCase()]['content'];
        html += "<div class='method " + method_name + "'>";
        html += '<div class="header">';
        html += "<div class='name " + method_name + "'>" + method_name + "</div>";
        html += "<div class='url'><a href='#!" + resource + "#" + (method.toLowerCase()) + "'>" + field['url'] + "</a></div>";
        html += "<div class='desc'>" + field['title'] + "</div>";
        html += '</div>';
        html += "<div class='form'>" + (this.add_form(method.toLowerCase(), entries[method.toLowerCase()])) + "</div>";
        html += "<div class='content'>" + content + "</div>";
        html += "</div>";
      }
      html += '</div>';
      return html;
    };

    Resource.prototype.add_form = function(method, config) {
      var form;
      form = new ResourceForm(method, config);
      return form.build();
    };

    return Resource;

  })();

  Utils = (function() {
    function Utils() {
      return;
    }

    Utils.prototype.toggle_by_class = function(clazz) {
      var elem, elems, _i, _len;
      elems = document.getElementsByClassName(clazz);
      for (_i = 0, _len = elems.length; _i < _len; _i++) {
        elem = elems[_i];
        console.log(elem);
        $(elem).toggle(false);
      }
    };

    Utils.prototype.default_config_url = function() {
      var pn;
      pn = window.location.pathname;
      pn = pn.replace(pn.substring(pn.lastIndexOf('/') + 1, pn.length), '');
      return "" + window.location.origin + pn + "data.json";
    };

    return Utils;

  })();

}).call(this);
