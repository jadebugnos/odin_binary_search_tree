require_relative "node"
require_relative "sortable"

# this file defines the Tree class
class Tree
  include Sortable

  attr_accessor :array, :root

  def initialize(data_arr)
    @data_arr = data_arr
    @root = nil
  end

  def build_tree_recur(arr, start, last)
    # base case
    return nil if start > last

    # Find the middle element
    mid = (start + last) / 2
    # Set the mid of arr the root node
    root = Node.new(arr[mid])

    # create the left subtree
    root.left = build_tree_recur(arr, start, mid - 1)
    # create the right subtree
    root.right = build_tree_recur(arr, mid + 1, last)

    root
  end

  def build_tree(arr)
    @root = build_tree_recur(arr, 0, arr.length - 1)
  end

  # method to insert a new node with the given key
  def insert(key, root = @root)
    return Node.new(key) if root.nil?

    if key <= root.data
      root.left = insert(key, root.left)
    elsif key > root.data
      root.right = insert(key, root.right)
    end

    root
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
