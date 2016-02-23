=begin
Question 1
In this programming problem and the next you'll code up the knapsack algorithm from lecture. 
Let's start with a warm-up. Download the text file here. This file describes a knapsack instance, 
and it has the following format:
[knapsack_size][number_of_items]
[value_1] [weight_1]
[value_2] [weight_2]
...
For example, the third line of the file is "50074 659", 
indicating that the second item has value 50074 and size 659, respectively.
You can assume that all numbers are positive. You should assume that item weights and 
the knapsack capacity are integers.
In the box below, type in the value of the optimal solution.
ADVICE: If you're not getting the correct answer, 
try debugging your algorithm using some small test cases. 
And then post them to the discussion forum!

A[0(item),x(weight)] = 0
A[i,x]
for i = 1 to n
 for x = 0 to W
  (pick the current item and the rest weight with the max value or the max value which does not include current item)
  A[i, x] = max[ Vi + A[i-1,x-wi], A[i-1,x]] 
=end
def knapsack (total_w, wt, val, n)
  k= []
  (0..n).each do |x|
  	k<<[]
  end
  (0..n).each do |i|
    (0..total_w).each do |w|
      if w == 0 || i ==0
        k[i][w] = 0
      elsif w >= wt[i-1]
      	if (val[i-1] + k[i-1][w - wt[i-1]]) > k[i-1][w]
           k[i][w] = val[i-1] + k[i-1][w - wt[i-1]]
        else
           k[i][w] = k[i-1][w]
        end
      else
        k[i][w] = k[i-1][w]
      end
    end
  end
  return k[n][total_w]  
end

def mergeSort(array)
  if array.length < 2
    return array 
  end
  mid = array.length/2
  left_array = array.slice(0, mid)
  right_array = array.slice(mid, array.length - mid)
  array_1 = mergeSort(left_array)
  array_2 = mergeSort(right_array)
  merge(array_1, array_2)
end

def merge(array_1,array_2)
  array = []
  i = 0
  j = 0
  while i < array_1.length && j < array_2.length
    if array_1[i][1] < array_2[j][1]
  	    array << array_1[i]
        i += 1
    else
      array << array_2[j]
      j += 1
    end
  end
  while i < array_1.length
  	array << array_1[i]
  	i += 1
  end
  while j < array_2.length
  	array << array_2[j]
  	j += 1 
  end
  return array 
end

def file_to_array
  item_num = 0
  total_w = 0
  c = []
  i = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/knapsack1.txt','r') do |f|
    f.each_line do |line|
      array = line.gsub("\n"," ").split(" ")
      array.map! do |s|
        s.to_i
      end
      c<<array
    end
    total_w = c[0][0]
    item_num = c[0][1]
  end
  c.delete_at(0)
  return item_num, total_w, c   
end

item_num, total_w, c = file_to_array

sort_c = mergeSort(c)

val = []
wt = []
(0..sort_c.length-1).each do |i|
  val[i] = sort_c[i][0]
  wt[i] = sort_c[i][1]
end

puts knapsack(total_w, wt, val, item_num)

