require 'json'

class String
  def santa_value
    0
  end
end

class Integer
  def santa_value
    self
  end
end

class Array
  def santa_value
    self.inject(0) { |sum, v| sum += v.santa_value }
  end
end

class Hash
  def santa_value
    return 0 if self.values.include?("red")
    return self.values.santa_value
  end
end

input = JSON.parse(gets.strip)
puts input.santa_value
