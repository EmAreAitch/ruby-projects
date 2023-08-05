class Node
  include Comparable
  attr_accessor :value, :left_node, :right_node

  def initialize(value)
    @value = value
  end

  def <=>(node)
    return self.value - node.value
  end
end

class Tree
  attr_accessor :root

  def initialize(values)
    @root = build_tree(values)
  end

  def build_tree(values)
    values.uniq!
    @root = Node.new(values.first)
    values.drop(1).each do |i|
      temp = root
      newnode = Node.new(i)
      loop do
        if temp > newnode
          if temp.left_node.nil?
            temp.left_node = newnode
            break
          else
            temp = temp.left_node
          end
        else
          if temp.right_node.nil?
            temp.right_node = newnode
            break
          else
            temp = temp.right_node
          end
        end
      end
    end
    root
  end

  def insert(value)
    temp = root
    newnode = Node.new(value)
    loop do
      if temp > newnode
        if temp.left_node.nil?
          temp.left_node = newnode
          break
        else
          temp = temp.left_node
        end
      else
        if temp.right_node.nil?
          temp.right_node = newnode
          break
        else
          temp = temp.right_node
        end
      end
    end
  end

  def delete(value, node = @root)
    if node.nil?
      return node
    end

    if (value < node.value)
      node.left_node = delete(value, node.left_node)
    elsif (value > node.value)
      node.right_node = delete(value, node.right_node)
    else
      if node.left_node.nil? || node.right_node.nil?
        temp = node.right_node.nil? ? node.left_node : node.right_node
        node = nil
        @root = temp if root.value == value
        return temp
      else
        temp = node.right_node
        while temp.left_node
          temp = temp.left_node
        end
        node.value = temp.value
        node.right_node = delete(temp.value, node.right_node)
      end
    end
    node
  end

  def find(value)
    temp = root
    while temp
      if temp.value > value
        temp = temp.left_node
      elsif temp.value < value
        temp = temp.right_node
      else
        break
      end
    end
    temp
  end

  def level_order
    queue = [root]
    output = []
    until queue.empty?
      node = queue.shift
      unless (node.left_node.nil?)
        queue << node.left_node
      end
      unless (node.right_node.nil?)
        queue << node.right_node
      end
      output << (block_given? ? yield(node) : node.value)
    end
    output
  end

  def inorder(node = @root, &block)
    return [] if node.nil?

    left_subtree = block_given? ? inorder(node.left_node, &block) : inorder(node.left_node)
    current_node = [(block_given? ? block.call(node) : node.value)]
    right_subtree = block_given? ? inorder(node.right_node, &block) : inorder(node.right_node)

    return left_subtree + current_node + right_subtree
  end

  def preorder(node = @root, &block)
    return [] if node.nil?

    current_node = [(block_given? ? block.call(node) : node.value)]
    left_subtree = block_given? ? preorder(node.left_node, &block) : preorder(node.left_node)
    right_subtree = block_given? ? preorder(node.right_node, &block) : preorder(node.right_node)

    return current_node + left_subtree + right_subtree
  end

  def postorder(node = @root, &block)
    return [] if node.nil?

    left_subtree = block_given? ? postorder(node.left_node, &block) : postorder(node.left_node)
    right_subtree = block_given? ? postorder(node.right_node, &block) : postorder(node.right_node)
    current_node = [(block_given? ? block.call(node) : node.value)]

    return left_subtree + right_subtree + current_node
  end

  def height(node = @root)
    return -1 if node.nil?

    return 1 + [height(node.left_node), height(node.right_node)].max
  end

  def depth(value, node = @root)
    return -1 if node.nil?

    return 0 if node.value == value

    left_depth = depth(value, node.left_node)
    return left_depth + 1 if left_depth >= 0

    right_depth = depth(value, node.right_node)
    return right_depth + 1 if right_depth >= 0

    return -1
  end

  def balanced?(node = @root)
    if node.nil?
      return true
    end

    if (height(node.left_node) - height(node.right_node)).abs <= 1 && balanced?(node.left_node) && balanced?(node.right_node)
      return true
    end

    return false
  end

  def balance_ary(arr)
    return arr if arr.size <= 1
    mid = arr.size / 2
    return [arr[mid]] + balance_ary(arr[0..mid - 1]) + balance_ary(arr[mid + 1..])
  end

  def rebalance()
    ary= inorder()
    balanced_ary = balance_ary(ary)
    build_tree(balanced_ary)
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right_node
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left_node
  end
end

arr = (Array.new(15) { rand(1..100) })
print "\n\n#{arr}\n\n"
tree = Tree.new(arr)
tree.pretty_print
puts "\n\nTree is balanced? #{tree.balanced?}\n\n"
print "Preorder: #{tree.preorder}\n\n"
print "Inorder: #{tree.inorder}\n\n"
print "Postorder: #{tree.postorder}\n\n"
tree.rebalance
print "Tree after rebalancing..\n\n"
tree.pretty_print
puts "\n\nTree is balanced? #{tree.balanced?}\n\n"
print "Preorder: #{tree.preorder}\n\n"
print "Inorder: #{tree.inorder}\n\n"
print "Postorder: #{tree.postorder}\n\n"

