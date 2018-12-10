points = []  # Array of positions: [x, y, vx, vy]

def print(points, extremes)
    xm, ym = extremes
    (ym[0] .. ym[1]).each do |y|
        line = ""
        (xm[0] .. xm[1]).each do |x|
            if points.select {|p| p[0] == x && p[1] == y}.length > 0
                line += "#"
            else
                line += " "
            end
        end
        puts line
    end
end

def move(points)
    points.each do |point|
        point[0] += point[2]
        point[1] += point[3]
    end
end

# TODO Not too fond of this, but it is convenient.
def back_in_time(points)
    points.each do |point|
        point[0] -= point[2]
        point[1] -= point[3]
    end
end

def extremes(points)
    xpoints = points.map { |p| p[0] }
    ypoints = points.map { |p| p[1] }
    [ [xpoints.min, xpoints.max], [ypoints.min, ypoints.max] ]
end

while line = gets
    x, y, vx, vy = line.strip.match(/^position=<([\s\-0-9]+), ([\s\-0-9]+)> velocity=<([\s\-0-9]+), ([\s\-0-9]+)>/).captures.map(&:to_i)
    points << [x, y, vx, vy]
end

seconds = 0
min_height = nil

while true
    extremes = extremes(points)
    height = (extremes[1][1] - extremes[1][0]).abs

    if min_height == nil || height < min_height
        min_height = height
    else
        # We're one step too far once we know we're at the minimum: move back.
        back_in_time(points) 
        print(points, extremes)
        exit
    end

    seconds += 1
    move(points)
end