class Links < Array
    def next_steps(following)
        self.select { |from, to| from == following}.map { |from, to| to }
    end
    
    def prev_steps(earlier)
        self.select { |from, to| to == earlier}.map { |from, to| from }
    end

    def no_prev_steps
        self.select { |from, to| self.prev_steps(from) == [] }.map(&:first).uniq
    end
end

links = Links.new
step_ids = Array.new

while line = gets
    break if line.strip.empty?

    from, to = line.match(/^Step (.+) must be finished before step (.+) can begin./).captures
    links << [from, to]

    step_ids << from unless step_ids.include?(from)
    step_ids << to unless step_ids.include?(to)
end

step_ids.sort!

PLUS = 60
WORKERS = 5

steps = Hash.new
step_ids.each { |id| steps[id] = [0, id.ord - "A".ord + 1 + PLUS] }

# Find possible beginning steps.
queue = links.no_prev_steps.sort
visited = []
workers = Array.new(WORKERS)

def redistribute_workers(queue, steps, workers)
    # puts "redistribute_workers(%s, steps, %s)" % [queue, workers]

    # Stop workers on completed steps.
    workers.each.with_index do |worker, index|
        workers[index] = nil if worker != nil && steps[worker][0] >= steps[worker][1]
    end

    # Reassign idle workers.
    available = queue.sort.reject { |step| workers.include?(step) }
    workers.each_with_index do |worker, index|
        if worker == nil
            workers[index] = available.shift
        end
    end
    # puts "->                  (%s, steps, %s)" % [queue, workers]
end

def work_on_queue(queue, steps, workers)
    # puts "working on: " + workers.to_s

    # Work on tasks.
    queue.each { |task|
        if workers.include?(task)
            # Increase seconds worked on.
            steps[task][0] += 1
        end
    }
end

def steps_ready(steps)
    steps.select { |id, counters| counter[0] >= counter[1] }
end

seconds = 0

until queue.empty?  # TODO Fix end condition.
    redistribute_workers(queue, steps, workers)

    # Work on items in queue with workers.
    work_on_queue(queue, steps, workers)

    # TODO Only shift steps from queue if they are done.
    ready = queue.select { |item| steps[item][0] >= steps[item][1] }

    # Process all ready steps.
    next_steps = []
    ready.each { |step|
        step = queue.delete(step)

        # Add step to list of visited steps.
        visited << step

        next_steps += links.next_steps(step)

        next_steps.reject! { |step|
            visited.include?(step) ||
            queue.include?(step) ||
            (links.prev_steps(step) & visited).length != links.prev_steps(step).length
        }
    }

    # Add all steps to queue, and sort queue.
    next_steps.each { |step| queue << step }
    queue.sort!

    seconds += 1
end

puts seconds