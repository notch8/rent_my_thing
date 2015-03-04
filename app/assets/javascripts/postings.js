jQuery(function($) {
  $(document).ready( function() {
    //enabling stickUp on the '.navbar-wrapper' class
    $('.navbar-wrapper').stickUp();
  });
});

$(document).on ('page:change', function() {
  if ($("#from-date").size() > 0){
    $( "#from-date" ).datepicker();
    $( "#to-date" ).datepicker();
  }
});
