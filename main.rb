require "pry-byebug"
require_relative "lib/tree"

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
test = Tree.new(array)

test.build_tree
# test.pretty_print
test.insert(45)
test.insert(46)
test.insert(10)
test.delete(46)
test.insert(46)
test.delete(23)
test.pretty_print
p test.balance?

test.rebalance
test.pretty_print
p test.balance?
