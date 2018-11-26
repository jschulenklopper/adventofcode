require 'digest'

def md5(string)
    Digest::MD5.hexdigest(string)
end

class String
    def is_integer?
      true if Integer(self) rescue false
    end
end

