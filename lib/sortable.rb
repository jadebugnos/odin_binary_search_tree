# this file defines the sortable module which holds the sorting algorithm for the data
module Sortable
  def merge_sort(array)
    # base case
    return array if array.size == 1

    # Find the middle element
    mid = (array.length / 2.0).ceil

    # break the array into two equal parts
    first_half = array[0...mid]
    second_half = array[mid..]

    # Recursively repeat until you hit the base case (1 element array)
    a = merge_sort(first_half)
    b = merge_sort(second_half)

    merge(a, b)
  end

  def merge(a, b) # rubocop:disable Naming/MethodParameterName
    arr = []

    while !a.empty? && !b.empty?
      if a[0] >= b[0]
        arr.push(b.shift)
      elsif b[0] > a[0]
        arr.push(a.shift)
      end
    end
    arr.concat(a).concat(b)
  end
end
