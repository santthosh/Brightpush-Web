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
  
  write_it(payload, "#id_payload");
}

get_payload();
$('#notify input:text').keyup(get_payload)
});
