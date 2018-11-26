require 'json'

def value(thing)
  return 0 if thing.is_a?(String)

  return thing if thing.is_a?(Integer)

  if thing.is_a?(Array)
    return thing.inject(0) { |sum, v| sum += value(v) }
  end

  if thing.is_a?(Hash)
    return value(thing.values)
  end
end

input = JSON.parse(gets.strip)
puts value(input)