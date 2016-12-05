require 'digest'

password = ""
input = gets.strip

start = 0
until password.length == 8
  hash = Digest::MD5.hexdigest(input + start.to_s)
  password << hash[5] if hash[0,5] == "00000" 
  start += 1
end  

puts password
