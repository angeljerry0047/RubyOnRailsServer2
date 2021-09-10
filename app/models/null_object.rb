class NullObject
  def method_missing(m, *args, &block)
    nil
  end
end