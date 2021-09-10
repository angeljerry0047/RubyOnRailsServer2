# FIXME (cmhobbs+tyreldenison) move this to lib
class TimeInterval
  CODES = YAML::load_file(Rails.root.join('./config/time_intervals.yml'))

  def self.times
    CODES.values
  end

  def self.all
    CODES.keys.sort.map do |k|
      [CODES[k], k]
    end
  end
end
