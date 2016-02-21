=begin
Question 2
In this question your task is again to run the clustering algorithm 
from lecture, but on a MUCH bigger graph. So big, in fact,
that the distances (i.e., edge costs) are only defined implicitly, 
rather than being provided as an explicit list.

The data set is here. The format is:
[# of nodes] [# of bits for each node's label]
[first bit of node 1] ... [last bit of node 1]
[first bit of node 2] ... [last bit of node 2]
...
For example, the third line of the file "0 1 1 0 0 1 1 0 0 1 0 1 1 1 1 1 1 0 1 0 1 1 0 1" 
denotes the 24 bits associated with node #2.

The distance between two nodes u and v in this problem is defined as the Hamming distance--- 
the number of differing bits --- between the two nodes' labels. For example, 
the Hamming distance between the 24-bit label of node #2 above and the label
 "0 1 0 0 0 1 0 0 0 1 0 1 1 1 1 1 1 0 1 0 0 1 0 1" is 3 (since they differ in the 3rd, 
 7th, and 21st bits).

The question is: what is the largest value of k such that there is 
a k-clustering with spacing at least 3? That is, how many clusters are 
needed to ensure that no pair of nodes with all but 2 bits in common get 
split into different clusters?

NOTE: The graph implicitly defined by the data file is so big that you 
probably can't write it out explicitly, let alone sort the edges by cost. 
So you will have to be a little creative to complete this part of the question. 
For example, is there some way you can identify the smallest distances without explicitly 
looking at every pair of nodes?  
=end
def max_space(array, bits, total_vertex)
  hd_bit1 = [1]
  (1..bits-1).each do |i|
    hd_bit1 << hakmemItem175(hd_bit1[i-1])
  end
  hd_bit2 = [3]
  # 24 choose 2 is 276
  (1..275).each do |i|
    hd_bit2 << hakmemItem175(hd_bit2[i-1])
  end
  hash_table = create_hash_table_bucket(array, 99971)
  result_dis1 = vertex_dis(array, hd_bit1, hash_table, 1, 99971)
  result_dis2 = vertex_dis(array, hd_bit2, hash_table, 2, 99971)
  edges_sort = []
  (0..result_dis1.length-1).each do |i|
    edges_sort << result_dis1[i]
  end
  (0..result_dis2.length-1).each do |i|
    edges_sort << result_dis2[i]
  end
  vertex_num = total_vertex
  result = []
  parent = []
  #each vertex is leader for itself
  (0..vertex_num -1).each do |i|
    parent[i] = [i+1, 0]
  end
  i = 0
  cluster_num = vertex_num
  (0..edges_sort.length-1).each do |i|
    parent_v1 = find(parent, edges_sort[i][0])
    parent_v2 = find(parent, edges_sort[i][1])
    if parent_v1!=parent_v2
    	result << edges_sort[i]
    	union(parent, parent_v1, parent_v2)
      cluster_num -=1
    end
  end
  return cluster_num 
end
# a XOR b =c
# a XOR c = a so if a is dis 1 so if can get c in the origin array then b , c are dis 1 
def vertex_dis(array, hd, hash_table, bit, hash_size)
  result = []
  constant = bit
  (0..(hd.length)-1).each do |i|
    (0..array.length-1).each do |j|
      a = hd[i]^array[j][1]
      index = a%hash_size
      (0..hash_table[index].length-1).each do |k|
        if (hash_table[index][k][1] == a) && (hash_table[index][k][1]^hd[i]==array[j][1])
          result << [ hash_table[index][k][0], array[j][0], constant]
        end
      end
    end    
  end
  return result
end

def create_hash_table_bucket(array, vertex_num)
  hash_size = vertex_num
  hash_table = []
  (0..hash_size - 1).each do |i|
    hash_table[i] = []
  end
  (0..array.length-1).each do |i|
    index = array[i][1]%hash_size
    hash_table[index] << array[i]
  end
  return hash_table
end

def hakmemItem175(value)
  # find the lowest one bit in the input
  lowest_one_bit = value & (-value)
  # determine the leftmost bits of the output
  leftBits = value + lowest_one_bit
  # determine the difference between the input and leftmost output bits
  changedBits = value ^ leftBits
  # determine the rightmost bits of the output
  rightBits = (changedBits / lowest_one_bit) >> 2
  # return the complete output
  return (leftBits | rightBits)
end


# utility function to find the subset of an element 
def find(parent, vertex)
  if parent[vertex-1][0] != vertex
    parent[vertex-1][0] = find(parent, parent[vertex-1][0])
  else
  	return vertex
  end
end


def union(parent, vertex_1, vertex_2)
  xroot = find(parent, vertex_1)
  yroot = find(parent, vertex_2)
  if parent[xroot-1][1] < parent[yroot-1][1]
    parent[xroot-1][0] = yroot
  elsif parent[xroot-1][1] > parent[yroot-1][1]
    parent[yroot-1][0] = xroot
  else
    parent[xroot-1][0] = yroot
    parent[yroot-1][1] += 1
  end
end

def file_to_array
  c = []
  a = []
  total_vertex = 0
  i = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/clustering_big.txt','r') do |f|
    f.each_line do |line|
      if i == 0
        array = line.gsub("\n"," ").split(" ")
        array.map! do |s|
          s.to_i
        end
        c << array
      else
        array = line.gsub("\n"," ")
        c << array.gsub(/\s+/, "").to_i(2)
      end
      i += 1
    end
  end
  c.delete_at(0)
  # 0000 and 0000 are distance 0 which is the same point so remove duplicate
  c.uniq!
  (0..c.length-1).each do |i|
    a<< [ i+1, c[i]]
  end
  require 'pry'
  binding.pry
  total_vertex = a.length
  return total_vertex, a
end

total_vertex, c = file_to_array

puts max_space(c , 24, total_vertex)




