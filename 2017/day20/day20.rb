class Particle
  attr_reader :p

  def initialize(p, v, a)
    @p, @v, @a = p, v, a
  end

  def update
    [0,1,2].each { |i| @v[i] += @a[i]; @p[i] += @v[i] }
  end

  def distance(pos)
    return (@p[0]-pos[0]).abs + (@p[1]-pos[1]).abs + (@p[2]-pos[2]).abs
  end
end

Stable = 1000

def main(file)
  particles = []

  File.open(file).readlines.each do |line|
    temp = Hash.new
    line.scan(/([pva]=<.*?>)/) do |m|
      xyz = m[0].scan(/[-]?[0-9]+/).map(&:to_i)  # FIXME This could be a Vector
      temp[m[0][0]] = xyz # That m[0][0] is the type of scalar.
    end
    particles << Particle.new(temp["p"], temp["v"], temp["a"])
  end

  # Consider situation stable after number of cycles without change.
  stable = Stable
  min_d = nil

  while stable > 0
    # Update positions.
    particles.each { |p| p.update }

    # Make list of unique positions.
    to_be_removed = particles.inject(Hash.new(0)) { | hash, part|
      hash[part.p] += 1; hash
    }.select { |k,v| v > 1 }

    # Remove colliding particles. Remove this section for part A.
    particles.reject! { |part| to_be_removed.include?(part.p) }

    # Find particle with minimum distance from [0,0,0].
    distances = []
    particles.each_with_index do |part, idx|
      distances[idx] = part.distance([0,0,0])
    end
    d = distances.find_index(distances.min)

    if d != min_d 
      stable = Stable  # Reset stable counter.
      min_d = d
    else
      stable -= 1
    end
  end

  [min_d, particles.length]
end

if __FILE__ == $0
  puts main(ARGV.first)
end
