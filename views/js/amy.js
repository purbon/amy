$(document).ready(function(){ 
  $(document).ready(function () { 
    var contents = document.getElementsByClassName("content")
    for(var j=0; j<contents.length; j++) {
       $(contents[j]).toggle(false);
    }
  }); 
}); 

function toggle(element) {
  var content = element.parentElement.parentElement.nextElementSibling.getElementsByClassName("content")[0];
  $(content).toggle("slow");
 }

 $(document).ready(function() {
   $.getJSON('data.json', function(data) {
      var resources = Object.keys(data['resources']);
      for(var i=0; i < resources.length; i++) {
          var resource = data['resources'][resources[i]];
          add_resource(resources[i], resource, i);
          $('#resource'+i).toggle();
      }
   });
 });

function toggleMethods(i) {
  $('#resource'+i).fadeToggle();
}
function add_resource(resource, config, i) {
  var html  = '<div class="resource">';
      html += '<div class="name">  <a href="#">'+resource+'</a> </div>';
      html += '<div class="title">'+config['title']+'</div>';
      html += '<div class="menu"> <a href="#" onclick="toggleMethods('+i+')">Show/Hide</a> | <a href="#">Raw</a> </div>';
      html += '</div>';
      html += add_section(resource, config['sections']['config'], i);
    $('.resources').append(html);
}

function add_section(resource, config, i) {
  var html  = '<div class="methods" id="resource'+i+'">';
  var methods = Object.keys(config);
  for(var i=0; i < methods.length; i++) {
        var field = config[methods[i]];
        html += '<div class="method">';
        html += '<div class="name">'+methods[i]+'</div>';
        html += '<div class="url"><a href="#">'+field['url']+'</a></div>';
        html += '<div class="desc">'+field['desc']+'</div>';
        html += '</div>';
  }
  html += '</div>';
  return html;
}
