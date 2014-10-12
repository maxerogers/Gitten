class Mew < ActiveRecord::Base
  belongs_to :repo

  def get_time
    self.time_string.to_time.strftime('%b %d %H:%M:%S')
  end
end
