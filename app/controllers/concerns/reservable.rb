module Reservable
  extend ActiveSupport::Concern

  def date_range_from_param param
    res = param.split ' - '
    logger.debug res
    start = Date.strptime res[0], '%m-%d-%Y'
    finish = Date.strptime res[1], '%m-%d-%Y'
    return start..finish
  end
end
