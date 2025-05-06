require_relative "node"

# this file defines the Tree class
class Tree
  attr_accessor :array

  def initialize(data_arr)
    @data_arr = data_arr
    @root = nil
  end

  def build_tree_recur(arr, start, last)
    return nil if start > last

    # Find the middle element
    mid = (start + last) / 2
    # Set the mid of arr the root node
    root = Node.new(arr[mid])

    root.left = build_tree_recur(arr, start, mid - 1)

    root.right = build_tree_recur(arr, mid + 1, last)

    root
  end

  def build_tree(arr)
    @root = build_tree_recur(arr, 0, arr.length - 1)
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
