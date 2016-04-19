//= require jquery.date-dropdowns.min.js
//= require jquery.datetimepicker.js

$( document ).ready(function() {
  $('#selectAll').on("change", function() {
    $("#submissions_form input[name='submission_ids[]']").each(function() {
      $(this).prop("checked", !$(this).prop("checked"));
    });
  });
});

(function($) {
    "use strict";
    //default date & time picker
    $('#datetimepicker').datetimepicker({
        dayOfWeekStart: 1,
        lang: 'en',
        format:'d/M/Y H:m',
        defaultDate: new Date()
    });
    $('#datetimepicker2').datetimepicker({
        dayOfWeekStart: 1,
        lang: 'en',
        format:'d/M/Y H:m',
        defaultDate: new Date()
    });
})(jQuery);


