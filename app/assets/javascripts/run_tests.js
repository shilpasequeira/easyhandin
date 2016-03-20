$(document).ready(function(){
  $("a#run_tests").bind(
    "ajax:success", 
    function(evt, data, status, xhr) {
      $("div#response_data p").text(data);
    }
  ).bind("ajax:error", function(evt, data, status, xhr){
      $("div#response_data p").text(data);
    }
  );
});
