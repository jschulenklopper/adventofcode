# Helper functions for Advent of Code solutions,
# not including libraries and methods in core and standard libraries.

# Most helpful core libraries:
# - Array, Enumerable
# - Hash
# - String, Struct, Integer, Numeric
# - Math
# - Regexp
# 
# Most helpful standard libraries:
# - Base64
# - Digest
# - Prime
# - Set, SortedSet

require 'open-uri'

# Reading Advent of Code input files.

INPUT_FILE = "input.txt"
COOKIE_JAR = "../../cookie.txt"
COOKIE = open(COOKIE_JAR).readline.strip

def read_input(year, day)
  unless FileTest.exist?(INPUT_FILE)
    # File doesn't exist locally, so get it first.
    url = "https://adventofcode.com/%s/day/%s/input" % [year, day]

    # Open URL and store contents in input file.
    begin
      open(url, "Cookie" => COOKIE) do |remote|
        File.open(INPUT_FILE, "wt") do |local|
          local.write(remote.read)
        end
      end
    rescue OpenURI::HTTPError
      STDERR.puts("Error reading %s" % url)
      exit
    end
  end

  # Read contents of input file and return as array of lines.
  File.readlines(INPUT_FILE).map(&:strip)  # Strip newline from each line.
end

# Trees, graphs


# Graph algorithms (tree, maze)


# Generic 2D grids


# Sparse grids
