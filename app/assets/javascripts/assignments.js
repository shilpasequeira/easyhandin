//= require jquery.date-dropdowns.min.js
//= require jquery.datetimepicker.js

$( document ).ready(function() {
  $('#selectAll').on("change", function() {
    $("#submissions_form input[name='submission_ids[]']").each(function() {
      $(this).prop("checked", !$(this).prop("checked"));
    });
  });
});



