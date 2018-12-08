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

# Compute value of a node
def value(node)
    if node == nil
        0
    elsif node[:children].empty?
        node[:metadata].sum
    else
        # TODO This should be doable with reduce.
        value = 0
        node[:metadata].each do |index|
            value += value(node[:children][index-1]) if index > 0
        end
        value
    end
end

# Read root node.
node, _ = read_node(numbers)

# Compute sum of all metadata entries.
puts value(node)