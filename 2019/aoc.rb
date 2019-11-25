# Module with helper functions for Advent of Code solutions.

require 'open-uri'

INPUT_FILE = "input.txt"
COOKIE_JAR = "../../cookie.txt"
COOKIE = open(COOKIE_JAR).readline.strip

def read_input(year, day)
  unless FileTest.exist?(INPUT_FILE)
    # File doesn't exist locally, so get it first.
    url = "https://adventofcode.com/%s/day/%s/input" % [year, day]

    # Open URL and store contents in input file.
    open(url, "Cookie" => COOKIE) do |remote|
      File.open(INPUT_FILE, "wt") do |local|
        local.write(remote.read)
      end
    end
  end

  # Read contents of input file and return as array of lines.
  File.readlines(INPUT_FILE).map(&:strip)  # Strip newline from each line.
end