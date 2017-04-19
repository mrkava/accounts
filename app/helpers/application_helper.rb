module ApplicationHelper
  def time_formatter(date)
    date.strftime('%m.%d.%Y, %H:%M')
  end

  def date_formatter(date)
    date.strftime('%m.%d.%Y')
  end
end
