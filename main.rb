require "pry-byebug"
require_relative "lib/tree"

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
test = Tree.new(array)

puts test.build_tree(array)
puts test.pretty_print
