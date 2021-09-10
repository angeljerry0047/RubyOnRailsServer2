# NOTE (cmhobbs) is this still relevant?
class PagesController < ApplicationController

  before_filter :authenticate_user!, :except => [:about, :speaker_series]

  def about
  end
end
