class Node
  attr_accessor :value, :next_node

  def initialize(value)
    @value = value
    @next_node = nil
  end
end

class LinkedList
  attr_reader :head, :tail

  def initialize(value = nil)
    unless value.nil?
      @head = Node.new(value)
      @tail = @head
    end
  end

  def append(value)
    unless head
      @head = Node.new(value)
      @tail = @head
    else
      tempNode = head
      while tempNode.next_node
        tempNode = tempNode.next_node
      end
      tempNode.next_node = Node.new(value)
      @tail = tempNode.next_node
    end
    head
  end

  def prepend(value)
    unless head
      append(value)
    else
      tempNode = Node.new(value)
      tempNode.next_node = head
      @head = tempNode
    end
    head
  end

  def size
    count = 0
    tempNode = head
    while tempNode
      count += 1
      tempNode = tempNode.next_node
    end
    count
  end

  def at(index)
    return "nil" if (index >= size)
    tempNode = head
    index.times do
      tempNode = tempNode.next_node
    end
    tempNode.value
  end

  def pop
    unless head && head.next_node
      @head, @tail = nil
    else
      tempNode = head
      while tempNode.next_node.next_node
        tempNode = tempNode.next_node
      end
      tempNode.next_node = nil
      @tail = tempNode
    end
    head
  end

  def contains?(value)
    tempNode = head
    while tempNode
      return true if (tempNode.value == value)
      tempNode = tempNode.next_node
    end
    false
  end

  def find(value)
    tempNode = head
    index = 0
    while tempNode
      return index if (tempNode.value == value)
      tempNode = tempNode.next_node
      index += 1
    end
    nil
  end

  def to_s
    tempNode = head
    str = ""
    while tempNode
      str << "( #{tempNode.value} ) -> "
      tempNode = tempNode.next_node
    end
    str << "nil"
    str
  end
end

LL = LinkedList.new()

5.downto(0) do |i|
  puts LL.to_s
  LL.append(i)
end
6.upto(9) do |i|
  puts LL.to_s
  LL.prepend(i)
end
puts LL.to_s
puts "\n\nDoes the list contains 3? That's #{LL.contains?(3)}"
puts "Does the list contains 11? That's #{LL.contains?(11)}"
puts "Find position of 3: #{LL.find(3)}"

puts "\nPopping all the elements\n"
LL.size.times do
  puts LL.to_s
  LL.pop
end
puts LL.to_s


