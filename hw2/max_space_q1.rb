# http://codingrecipies.blogspot.tw/2013/09/max-spacing-for-k-order-cluster.html
# http://www.geeksforgeeks.org/greedy-algorithms-set-2-kruskals-minimum-spanning-tree-mst/
=begin
Question 1
In this programming problem and the next you'll code up the clustering algorithm
from lecture for computing a max-spacing k-clustering. Download the text file here.
This file describes a distance function (equivalently, a complete graph with edge costs). 
It has the following format:

[number_of_nodes]
[edge 1 node 1] [edge 1 node 2] [edge 1 cost]
[edge 2 node 1] [edge 2 node 2] [edge 2 cost]
...
There is one edge (i,j) for each choice of 1≤i<j≤n, where n is the number of nodes. 
For example, the third line of the file is "1 3 5250", 
indicating that the distance between nodes 1 and 3 
(equivalently, the cost of the edge (1,3)) is 5250. 
You can assume that distances are positive, 
but you should NOT assume that they are distinct.
Your task in this problem is to run the clustering algorithm from lecture on this data set,
where the target number k of clusters is set to 4.
What is the maximum spacing of a 4-clustering?
ADVICE: If you're not getting the correct answer,
try debugging your algorithm using some small test cases.
And then post them to the discussion forum!
=end

def max_space(array)
  # sort the edges in the increasing order of the weight
  edges_sort = mergeSort(array)
  vertex_num = 500
  result = []
  parent = []
  #each vertex is leader for itself
  (0..vertex_num -1).each do |i|
    parent[i] = [i+1, 0]
  end
  i = 0
  #while (result.length < vertex_num-1)
  cluster_num = vertex_num
  while (cluster_num >3)
    parent_v1 = find(parent, edges_sort[i][0])
    parent_v2 = find(parent, edges_sort[i][1])
    if parent_v1!=parent_v2
    	result << edges_sort[i]
    	union(parent, parent_v1, parent_v2)
      cluster_num -=1
    end
    i += 1
  end
  return edges_sort[i-1][2]
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
    if array_1[i][2] < array_2[j][2]
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

# A utility function to find set of an element i
# (uses path compression technique)
def find(parent, vertex)
  # find root and make root as parent of i (path compression)
  if parent[vertex-1][0] != vertex
    parent[vertex-1][0] = find(parent, parent[vertex-1][0])
  else
  	return vertex
  end
end
# A function that does union of two sets of x and y
# (uses union by rank)
def union(parent, vertex_1, vertex_2)
  xroot = find(parent, vertex_1)
  yroot = find(parent, vertex_2)
  # Attach smaller rank tree under root of high rank tree
  # (Union by Rank)
  if parent[xroot-1][1] < parent[yroot-1][1]
    parent[xroot-1][0] = yroot
  elsif parent[xroot-1][1] > parent[yroot-1][1]
    parent[yroot-1][0] = xroot
  # If ranks are same, then make one as root and increment
  # its rank by one
  else
    parent[xroot-1][0] = yroot
    parent[yroot-1][1] += 1
  end
end

c = []
i = 0
File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/clustering1.txt','r') do |f|
  f.each_line do |line|
    array = line.gsub("\n"," ").split(" ")
    array.map! do |s|
      s.to_i
    end
    if array.length >= 3
      c << array
    end
  end
end 

puts max_space(c)




