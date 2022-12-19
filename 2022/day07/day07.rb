class MyDir
  attr_accessor :name, :parent, :dirs, :files, :size

  def initialize(name, parent)
    @name = name
    @parent = parent
    @dirs = []
    @files = []
    @size = 0
  end

  def total_size
    @files.map { |f| f.size}.sum + @dirs.map { |f| f.total_size }.sum
  end
end

class MyFile
  attr_accessor :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end
end

$fs = MyDir.new("/", nil)
$cur_dir = $fs

lines = ARGF.readlines.map(&:strip)
idx = 0

while idx < lines.length do
  line = lines[idx]

  if line[0] == "$"
    _, cmd, arg = line.split(" ")
    if cmd == "cd" && arg == "/"
      $cur_dir = $fs
    elsif cmd == "cd" && arg == ".."
      $cur_dir = $cur_dir.parent
    elsif cmd == "cd"
      $cur_dir = $cur_dir.dirs.select { |d| d.name == arg }.first
    elsif cmd == "ls"
    end
  else
    one, two = line.split(" ")
    if one == "dir"
      new_dir = MyDir.new(two, $cur_dir)
      $cur_dir.dirs << new_dir
    else # this is a file
      $cur_dir.files << MyFile.new(two, one.to_i)
    end
  end

  idx += 1
end

puts "part 1"
$ceiling = 100000

# This is a hack to get all `MyDir` objects smaller than the ceiling.
puts ObjectSpace.each_object(MyDir).select { |d| d.total_size < $ceiling}
                                   .map { |d| d.total_size }.sum

puts "part 2"
available = 70000000
unused = available - $fs.total_size
necessary = 30000000
to_delete = necessary - unused

# Find smallest directory with size larger than `to_delete`.
puts ObjectSpace.each_object(MyDir).select { |d| d.total_size > to_delete}
                                   .map { |d| d.total_size }.sort.first
