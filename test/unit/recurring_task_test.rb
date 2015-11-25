require_relative '../test_helper.rb'

class RecurringTaskTest < ActiveSupport::TestCase
  plugin_fixtures :issues, :recurring_tasks
  fixtures :projects, :users, :roles, :trackers, :projects_trackers,
           :issue_statuses, :enumerations, :enabled_modules

  def setup
    RecurringTask.any_instance.stubs :puts
  end

  def test_daily_recurrence
    task = RecurringTask.find fixture(:fixed_daily_recurrence)

    assert_difference -> { Issue.count }, 2 do
      task.recur_issue_if_needed!
    end
  end

  def test_based_on_start_date_validation
    task = RecurringTask.find fixture(:fixed_daily_recurrence)
    task.issue.update(start_date: 10.days.ago, due_date: Date.today-5.days)
    task.update(interval_number: 10)

    assert_equal task.next_scheduled_recurrence, task.issue.due_date+10.days
    task.update(recur_based_on_start_date: true)
    assert_equal task.next_scheduled_recurrence, task.issue.start_date+10.days
  end
end
