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

  # helper method to the #delete method to find the inorder successor
  def find_successor(node)
    current_node = node.right

    # Go the the leftmost node of the right subtree of the node we are deleting and return it
    current_node = current_node.left until current_node.left.nil?

    current_node
  end

  # Deletes a node based on the given key
  def delete(key, root = @root) # rubocop:disable Metrics/AbcSize
    # Base case
    return root if root.nil?

    # Navigates the BST:
    # if key is smaller, go left
    # if key is bigger, go right
    if root.data > key
      root.left = delete(key, root.left)
    elsif root.data < key
      root.right = delete(key, root.right)
    else
      # Cases when root has 0 children or only right child
      return root.right if root.left.nil?

      # When root has only left child
      return root.left if root.right.nil?

      # When both children are present
      successor = find_successor(root)
      root.data = successor.data
      root.right = delete(successor.data, root.right)
    end
    root
  end

  # Navigates the BST until a node is nil or the node is found based on the key
  # and returns it otherwise nil
  def find(key, current_node = @root)
    until current_node.nil?
      if key > current_node.data
        current_node = current_node.right
      elsif key < current_node.data
        current_node = current_node.left
      else
        return current_node
      end
    end
    nil
  end

  def level_order(root = @root)
    return if root.nil?

    queue = [root]
    values = []

    until queue.empty?
      node = queue.shift

      if block_given?
        yield(node)
      else
        values << node.data
      end

      queue.push(node.left) if node.left

      queue.push(node.right) if node.right
    end

    values unless block_given?
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
