=begin
Question 2
This problem also asks you to solve a knapsack instance, but a much bigger one.
Download the text file here. This file describes a knapsack instance,
 and it has the following format:
[knapsack_size][number_of_items]
[value_1] [weight_1]
[value_2] [weight_2]
...
For example, the third line of the file is "50074 834558", 
indicating that the second item has value 50074 and size 834558, respectively. 
As before, you should assume that item weights and the knapsack capacity are integers.
This instance is so big that the straightforward iterative implemetation uses an infeasible amount
of time and space. So you will have to be creative to compute an optimal solution. 
One idea is to go back to a recursive implementation, solving subproblems --- 
and, of course, caching the results to avoid redundant work --- 
only on an "as needed" basis. Also, be sure to think about appropriate data 
structures for storing and looking up solutions to subproblems.
In the box below, type in the value of the optimal solution.

ADVICE: If you're not getting the correct answer, 
try debugging your algorithm using some small test cases. 
And then post them to the discussion forum!
=end

def knapsack (total_w, wt, val, n)
  k= []
  current = 0
  (0..1).each do |x|
  	k<<[]
  end
  (0..n).each do |i|
    (0..total_w).each do |w|
      if w == 0 || i ==0
        k[current][w] = 0
      elsif w >= wt[i-1]
        if (val[i-1] + k[1-current][w - wt[i-1]]) >  k[1-current][w]
          k[current][w] = (val[i-1] + k[1-current][w - wt[i-1]])
        else
          k[current][w] = k[1-current][w]
        end
      else
        k[current][w] = k[1-current][w]
      end
    end
    current = 1 - current
  end
  return k[1-current][total_w]
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

def find_great_common_divisor(array)
  b = array[0][1].gcd(array[1][1])
  (2..array.length-1).each do |i|
     b = b.gcd(array[i][1])
  end
  return b
end

def file_to_array
  item_num = 0
  total_w = 0
  c = []
  i = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/knapsack_big.txt','r') do |f|
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
# find the greatest common divisor in the file for all weight
gcd = find_great_common_divisor(sort_c)

val = []
wt = []
(0..sort_c.length-1).each do |i|
  val[i] = sort_c[i][0]
  # divide the gcd for all weight and also the knapsack total weight
  # ex total w =60,  v1 = 2 w1=30 , v2=2 W2=20, W can only put 1 v1, 1 v2 which is the same as 
  # total w = 6, v1 =3 w1=3 , v2=2 w2= 2 which also only can put 1 v1,1 v2
  # 
  wt[i] = sort_c[i][1]/gcd
end
n = val.length
puts knapsack(total_w/gcd, wt, val, n)


