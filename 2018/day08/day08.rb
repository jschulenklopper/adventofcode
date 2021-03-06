numbers = gets.strip.split.map(&:to_i)

def read_node(numbers)
    return nil if numbers == []

    # Collect count of children and metadata entries.
    nr_children, nr_metadata = numbers[0], numbers[1]

    length = 2  # Length is minimal two: nr_children (1), nr_metadata (1).

    # Collect child nodes, recursively, processing pieces of numbers.
    children = []
    nr_children.times do
        child, size = read_node(numbers[length..-1])
        length += size
        children << child
    end

    # Collect metadata entries.
    metadata = numbers[length, nr_metadata]
    length += metadata.length

    # Store children and metadata in a node.
    node = { children: children, metadata: metadata}

    # Return node and total size of numbers processed.
    [node, length]
end

# Recursively compute value of node: total sum of metadata.
def sum_metadata(node)
    node[:metadata].sum + node[:children].map { |child| sum_metadata(child) }.sum
end

# Read root node.
node, _ = read_node(numbers)

# Compute sum of all metadata entries.
puts sum = sum_metadata(node)