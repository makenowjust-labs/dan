class String
  def ~
    margin = scan(/^ +/).min_by { |x| x.size }
    gsub(/^#{margin}/, '')
  end
end
