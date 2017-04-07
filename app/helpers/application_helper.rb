module ApplicationHelper
  def date_formatter(date)
    date.strftime('%m.%d.%Y, %H:%M')
  end
end
