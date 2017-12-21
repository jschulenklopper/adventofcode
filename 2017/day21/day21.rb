require 'matrix'

class Matrix
  def self.from_grid(grid)
    if grid.length > 0 && grid[0].length > 0
      Matrix.build(grid.length, grid[0].length) { |i,j| grid[i][j] }
    end
  end

  def self.join(minors)
    nr_per_side = Math.sqrt(minors.length)
    matrix = nil
    new_rows = []
    minors.each_slice(nr_per_side) do |row|
      new_row = row[1..-1].reduce(row[0]) do |sum, m|
        sum = sum.hstack(m)
      end
      new_rows << new_row
    end
    new_matrix = new_rows[1..-1].reduce(new_rows[0]) do |sum, r|
      sum = sum.vstack(r)
    end
  end

  def options
    # Generate all options / orientations of the matrix.
    options = [self]
    options << self.flip_rows
    options << self.flip_columns
    options << self.rotate
    options << self.rotate.flip_rows
    options << self.rotate.flip_columns
    options << self.rotate.rotate
    options << self.rotate.rotate.rotate
    options.uniq  # Make array unique
  end

  def flip_rows
    # Returns a new matrix with rows flipped.
    Matrix.rows(self.rows.reverse)
  end

  def flip_columns
    # Returns a new matrix with columns flipped.
    Matrix.columns(self.transpose.rows.reverse)
  end

  def rotate
    Matrix.rows(self.transpose.rows.map(&:reverse))
  end

  def to_s
    self.rows.map { |r| r.join }.join("\n")
  end

  def pixel_count
    self.each.count("#")
  end
end

ITERATIONS = 18  # For part 1, just 5 iterations.

def main(rule_file)
  rules = []
  rule_strings = File.open(rule_file).readlines.map(&:chomp)

  rule_strings.each do |string|
    from_string, to_string = string.split(" => ")
    from_grid = Matrix.from_grid(from_string.split("/"))
    to_grid = Matrix.from_grid(to_string.split("/"))
    rules << {:from => from_grid, :to => to_grid }  
  end

  # Expand all the rules by adding options for all inputs.
  expanded_rules = []
  rules.each do | rule |
    from = rule[:from]
    to = rule[:to]
    from.options.each do |option|
      expanded_rules << {:from => option, :to => to}
    end
  end

  grid = Matrix.from_grid([".#.", "..#", "###"])

  ITERATIONS.times do |iter|
    # Construct minors.
    minors = []
    divisor = (grid.column_count % 2 == 0) ? 2 : 3
    if grid.column_count % divisor == 0
      (0...grid.row_count).step(divisor).each do |i|
        (0...grid.column_count).step(divisor).each do |j|
          minors << grid.minor(i,divisor,j,divisor)
        end
      end
    end

    # For each of the minors, apply transformation if rule match.
    new_minors = []
    minors.each do |minor|
      expanded_rules.each do |rule|
        if rule[:from] == minor
          new_minors << rule[:to]
        end
      end
    end

    # Reconstruct grid from enhanced minors.
    grid = Matrix.join(new_minors)
  end

  # Count number of pixels.
  puts "pixel_count:"
  grid.pixel_count
end

if __FILE__ == $0
  puts main(ARGV[0])
end
