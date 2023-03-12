class String
  def bg_white
    "\e[47m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end
end
