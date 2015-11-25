$(document).on('change', 'input#recurring_task_fixed_schedule', onFixedScheduleChange);

$(document).ready(function() {
  updateRecurBasedOnStartDate($('input#recurring_task_fixed_schedule').prop('checked'));
});

function onFixedScheduleChange(event) {
  updateRecurBasedOnStartDate($(this).prop('checked'));
}

function updateRecurBasedOnStartDate(fixed_schedule) {
  fixed_schedule = (fixed_schedule == "1");

  if (fixed_schedule) {
   $('p.recur_based_on_start_date').show();
  } else {
   $("p.recur_based_on_start_date input").prop('checked', false);
   $('p.recur_based_on_start_date').hide();
  }
}

