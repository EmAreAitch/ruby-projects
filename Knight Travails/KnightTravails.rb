def knight_moves(start, stop)
  return {moves: 0, path: [start]} if start.eql?(stop)

  moves = [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
  visited = {start => true}
  queue = [[start]]

  while path = queue.shift
    position = path.last
    return {moves: path.size - 1, path: path} if position.eql?(stop)
    moves.each do |move|
      new_position = [position[0] + move[0], position[1] + move[1]]
      next unless new_position.all?{ |dim| dim.between?(0,7)}
      next if visited[new_position]
      visited[new_position] = true
      queue << path + [new_position]
    end
  end

  {moves: nil, path: nil}
end

hash = knight_moves([2, 3], [6, 1])
puts "You made it in #{hash[:moves]}! Here's your path:"
puts hash[:path].map(&:inspect)
