require 'digest'

input = ARGV[0]
start = 0
while start
  string = start.to_s
  hash = Digest::MD5.hexdigest(input + string)
  if hash[0,6] == "000000" 
    puts start
    break
  end
  start += 1
end  
