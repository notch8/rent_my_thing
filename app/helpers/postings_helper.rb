module PostingsHelper
  def date_range_string_for_js date_range
    if date_range
      start = date_range.begin
      finish = date_range.end
      "{minDate: new Date(#{start.year}, #{start.mon}, #{start.day}), maxDate: new Date(#{finish.year}, #{finish.mon}, #{finish.day})}"
    else
      ""
    end
  end
end
