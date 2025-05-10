require_relative "node"
require_relative "sortable"

# this file defines the Tree class
class Tree # rubocop:disable Metrics/ClassLength
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

  # Navigates the BST to find and return the node matching the given key.
  # If a block is given, it yields each visited node to the block.
  # returns nil if key is not found in the BST
  def find(key, current_node = @root)
    until current_node.nil?
      yield(current_node) if block_given? # added optional block for more functionality

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

  # traverse the BST in breadth-first order. optionally accepts a block;
  # if no block is given, it returns an array of node in level order.
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

  # Depth-first traversal methods for the BST.
  # Each method optionally accepts a block; if no block is given,
  # it returns an array of node values in the corresponding order.

  ## Preorder traversal: root -> left -> right
  def preorder(node = @root, values = [], &block)
    return values if node.nil?

    block ? block.call(node) : values << node.data

    preorder(node.left, values, &block)
    preorder(node.right, values, &block)

    values unless block
  end

  # postorder traversal: left -> right -> root
  def postorder(node = @root, values = [], &block)
    return if node.nil?

    postorder(node.left, values, &block)
    postorder(node.right, values, &block)

    block ? block.call(node) : values << node.data

    values unless block
  end

  # inorder traversal: left => root -> right
  def inorder(node = @root, values = [], &block)
    return if node.nil?

    inorder(node.left, values, &block)

    block ? block.call(node) : values << node.data

    inorder(node.right, values, &block)

    values unless block
  end

  # finds the hight of a node in the BST based on the given value
  def height(value)
    node = find(value)

    return nil if node.nil?

    find_height(node)
  end

  # helper method for the height method to recursively calculate the height of a node
  def find_height(node)
    return -1 if node.nil?

    left_height = find_height(node.left)
    right_height = find_height(node.right)

    yield(left_height, right_height) if block_given?

    [left_height, right_height].max + 1
  end

  # returns the depth (number of edges from the root) of the node with the given value.
  # returns nil if value is not found in the BST.
  def depth(value)
    edges = -1
    node = find(value) { |_node| edges += 1 } # utilize find method which have access to visited nodes
    return edges if node

    nil
  end

  # returns true if the BST is balanced otherwise returns false
  def balance?
    result = [true]

    postorder do |node|
      break unless result[0]

      find_height(node) do |left, right|
        result[0] = false if (left - right).abs > 1
      end
    end

    result[0]
  end

  # collects all the entries in the tree, removes duplicates,
  # sorts the values, and then rebuilds the BST to ensure it is balanced.
  def rebalance
    values = inorder.uniq
    sorted = merge_sort(values)
    build_tree(sorted)
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
