require 'digest'

password = {}
input = gets.strip

start = 0
until password.length == 8
  hash = Digest::MD5.hexdigest(input + start.to_s)
  if hash[0,5] == "00000" && hash[5].between?("0","7")
    position = hash[5].to_i
    character = hash[6]

    if ! password.has_key?(position)
      password[position] = character
    end
  end
  start += 1
end  

puts password.keys.sort.map {|k| password[k]}.join
