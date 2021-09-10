# FIXME (cmhobbs+tyreldenison) move this to lib
class UsState
  CODES = YAML::load_file(Rails.root.join('./config/us_states.yml'))
  
  def self.po_codes
    CODES.keys
  end
  
  def self.all
    CODES.keys.sort.map do |k|
      [CODES[k], k]
    end
  end
end
