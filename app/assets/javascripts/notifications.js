// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var write_it = function(json, selector) {
  $(selector).val(JSON.stringify(json));
}

function get_badge_value(badge_value) {
  var autobadge = false;
  if (badge_value == "auto") {
  autobadge = true;
  } else if (badge_value.indexOf("+") == 0) {
  autobadge = true;
  } else if (badge_value.indexOf("-") == 0) {
  autobadge = true;
  } else if (badge_value.indexOf("a") == 0) {
  // this allows them to type 'auto' without seeing 'NaN'
  autobadge = true;
}
if (autobadge) {
    return badge_value;
  } else {
   return parseInt(badge_value);
  }
}

var get_payload = function() {
  
  if($("#app_type").val() == 'android')
  {
    payload = {"android": {}}
    
    var id_alert = $("#id_alert").val();
    if (id_alert) {
    payload["android"]["alert"] = id_alert;
    }
    
    var extra_key = $("#id_extra_key").val();
    var extra_value = $("#id_extra_value").val();
    if (extra_key) {
    payload["android"]["extra"] = {}
    payload["android"]["extra"][extra_key] = extra_value;
    }
  
  }
  else
  {
    payload = {"aps": {}}
    
    var badge = $("#id_badge").val();
    if (badge) {
    payload["aps"]["badge"] = get_badge_value(badge);
    }
    
    var id_alert = $("#id_alert").val();
    if (id_alert) {
    payload["aps"]["alert"] = id_alert;
    }
    
    var sound = $("#id_sound").val();
    if (sound) {
    payload["aps"]["sound"] = sound;
    }
  }  
  
  write_it(payload, "#id_payload");
}

get_payload();
$('#notify input:text').keyup(get_payload)
});
