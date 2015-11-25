$(document).on('change', 'select#recurring_task_interval_unit', onUnitChanged);
$(document).on('change', 'input#recurring_task_fixed_schedule', onFixedScheduleChange);

$(document).ready(function() {
  updateIntervalModifier($('select#recurring_task_interval_unit').val());
  updateRecurBasedOnStartDate($('input#recurring_task_fixed_schedule').prop('checked'));
});

function onUnitChanged(event) {
  updateIntervalModifier($(this).val());
}

function onFixedScheduleChange(event) {
  updateRecurBasedOnStartDate($(this).prop('checked'));
}

function updateIntervalModifier(unit) {
  if (unit == 'd') {
    $('.day_interval_modifier select').prop('disabled', false);
    $('.day_interval_modifier').show();
  } else {
    $('.day_interval_modifier select').prop('disabled', true);
    $('.day_interval_modifier').hide();
  }

  if (unit == 'm') {
    $('.month_interval_modifier select').prop('disabled', false);
    $('.month_interval_modifier').show();
  } else {
    $('.month_interval_modifier select').prop('disabled', true);
    $('.month_interval_modifier').hide();
  }
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
