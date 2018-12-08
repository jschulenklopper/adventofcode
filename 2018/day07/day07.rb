
class Links < Array  # Not really an array, but a list of links.
    def next_steps(following)
        # TODO Can this be done nicer?
        self.select { |from, to| from == following}.map { |from, to| to }
    end
    
    def prev_steps(earlier)
        self.select { |from, to| to == earlier}.map { |from, to| from }
    end

    def no_prev_steps
        self.select { |from, to| 
            self.prev_steps(from) == []
        }.map(&:first).uniq.sort
    end
end

links = Links.new

while line = gets
    links << line.match(/^Step (.+) must be finished before step (.+) can begin./).captures
end

# Find possible beginning steps.
queue = links.no_prev_steps
visited = []

puts "queue: %s" % queue.to_s
puts "visited: %s" % visited.to_s

while step = queue.shift
    puts "---"
    puts "processing step: %s" % step.to_s

    # Add step to list of visited steps.
    visited << step

    next_steps = links.next_steps(step)
    puts "list of potential next steps: %s" % next_steps.to_s

    next_steps.reject! { |step|
        visited.include?(step) ||
        queue.include?(step) ||
        # als niet alle prevs van step in visited zitten
        (links.prev_steps(step) & visited).length != links.prev_steps(step).length
    }

    puts "list of next steps: %s" % next_steps.to_s

    # Add all steps to queue, and sort queue.
    next_steps.each { |step| queue << step }
    queue.sort!

    puts "queue: %s" % queue.to_s
    puts "visited: %s" % visited.to_s
end

puts "visited: %s" % visited.to_s
puts visited.join