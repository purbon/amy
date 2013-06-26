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
      add_resource_events();
      var anchor = window.location.hash.replace('!','');
          anchor = anchor.replace(/\//g,"\\/");
          anchor = anchor.replace(/:/g,'\\:');
      $(anchor).next().fadeToggle();
   });
 });

function toggleMethods(i) {
  event.stopPropagation();
  $('#resource'+i).fadeToggle();
}
function add_resource_events() {
  $(".resource").hover(function(){
    $(this).css("background", "#f5f5f5");
    $(this).children('div').children().css('color', 'black');
  }, function(){
    $(this).css("background", "#fff");
    $(this).children('div').children().css('color', '#999');
  });
  $('.resource').click(function(event) {
    event.stopPropagation();
    $(event.delegateTarget).next().fadeToggle();
  });
}
function add_resource(resource, config, i) {
  var html  = '<div class="resource" id="'+resource+'">';
      html += '<div class="name">  <a href="#!'+resource+'">'+resource+'</a> </div>';
      html += '<div class="title">'+config['title']+'</div>';
      html += '<div class="menu"> <a href="#" onclick="toggleMethods('+i+')">Show/Hide</a> | <a href="#">Raw</a> </div>';
      html += '</div>';
      html += add_section(resource, config['sections']['config'], config['sections']['entries'], i);
    $('.resources').append(html);
    $('#resource'+i+' .content').toggle()
}

function add_section(resource, config, entries, i) {
  var html  = '<div class="methods" id="resource'+i+'">';
  var methods = Object.keys(config);
  for(var i=0; i < methods.length; i++) {
        var field   = config[methods[i]];
        var content = entries[methods[i].toUpperCase()];
        html += '<div class="method '+methods[i]+'">';
        html += '<div class="header">';
        html += '<div class="name '+methods[i]+'">'+methods[i]+'</div>';
        html += '<div class="url"><a href="#">'+field['url']+'</a></div>';
        html += '<div class="desc">'+field['desc']+'</div>';
        html += '</div>';
        html += '<div class="content">'+content+'</div>';
        html += '</div>';
  }
  html += '</div>';
  return html;
}
function capitalise(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}
