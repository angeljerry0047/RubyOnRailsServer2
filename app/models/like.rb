# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  liker_type    :string(255)
#  liker_id      :integer
#  likeable_type :string(255)
#  likeable_id   :integer
#  created_at    :datetime
#

class Like < Socialization::ActiveRecordStores::Like

  # XXX (cmhobbs+tyreldenison) duplicate.
  def freshness
    @date = self.created_at.to_date
    @date40 = (Date.today - 40.days..Date.today - 31.days)
    @date30 = (Date.today - 30.days..Date.today - 21.days)
    @date20 = (Date.today - 20.days..Date.today - 11.days)
    @date10 = (Date.today - 10.days..Date.today - 6.days)
    @date5 = (Date.today - 5.days..Date.today - 1.day)
    case 
    when @date40.cover?(@date)
      1
    when @date30.cover?(@date)
      2
    when @date20.cover?(@date)
      3
    when @date10.cover?(@date)
      4
    when @date5.cover?(@date)
      5
    when @date == Date.today
      10    
    else 
      0  
    end
  end

end
