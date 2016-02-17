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

  def test_working_day_recurrence
    task = RecurringTask.find fixture(:fixed_working_day_recurrence)
    issue = Issue.find fixture(:basic_issue)
    issue.update start_date: Date.today.beginning_of_week-3.weeks,
                 due_date: Date.today.beginning_of_week-3.weeks+1.day

    Timecop.freeze(Date.today.beginning_of_week) do
      assert_difference -> { Issue.count }, 15 do
        task.recur_issue_if_needed!
      end
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

  def test_weekly_recurrence_based_on_start_date
    task = RecurringTask.find fixture(:fixed_weekly_recurrence)

    Timecop.freeze(Date.today.beginning_of_week+5.days) do
      assert_equal task.need_to_recur?, false
    end

    Timecop.freeze(Date.today.beginning_of_week+11.days) do
      assert_equal task.need_to_recur?, true
    end
  end

  def test_weekly_recurrence_based_on_start_date_backlog
    task = RecurringTask.find fixture(:fixed_weekly_recurrence)

    Timecop.freeze(Date.today.beginning_of_week+5.days) do
      assert_equal task.need_to_recur?, false
    end

    Timecop.freeze(Date.today.beginning_of_week+11.days) do
      assert_difference -> { Issue.count }, 1 do
        task.recur_issue_if_needed!
      end
    end
  end

  def test_removes_closed_on
    task = RecurringTask.find fixture(:fixed_daily_recurrence)
    task.issue.status = IssueStatus.find_by(name: "Closed")
    task.issue.save

    assert_not_nil task.issue.closed_on
    task.recur_issue_if_needed!
    assert_nil task.issue.closed_on
  end
end
