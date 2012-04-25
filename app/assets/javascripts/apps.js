// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $('#app_development_push_certificate').change(function(){
    $('#app_crypted_development_push_certificate_password').attr("disabled",false);  
    });
  $('#app_production_push_certificate').change(function(){
    $('#app_crypted_production_push_certificate_password').attr("disabled",false);  
    });
});