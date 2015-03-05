$(document).on ('page:change', function() {
  if ($("#from-date").size() > 0){
    $( "#from-date" ).datepicker();
    $( "#to-date" ).datepicker();
  }
});
