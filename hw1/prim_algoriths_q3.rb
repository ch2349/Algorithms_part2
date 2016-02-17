#http://www.geeksforgeeks.org/greedy-algorithms-set-5-prims-minimum-spanning-tree-mst-2/
=begin 
Question 3
In this programming problem you'll code up Prim's minimum spanning tree algorithm. Download the text file here. This file describes an undirected graph with integer edge costs. It has the format

[number_of_nodes] [number_of_edges]
[one_node_of_edge_1] [other_node_of_edge_1] [edge_1_cost]
[one_node_of_edge_2] [other_node_of_edge_2] [edge_2_cost]
...
For example, the third line of the file is "2 3 -8874", indicating that there is an edge connecting vertex #2 and vertex #3 that has cost -8874. You should NOT assume that edge costs are positive, nor should you assume that they are distinct.

Your task is to run Prim's minimum spanning tree algorithm on this graph. You should report the overall cost of a minimum spanning tree --- an integer, which may or may not be negative --- in the box below.

IMPLEMENTATION NOTES: This graph is small enough that the straightforward O(mn) time implementation of Prim's algorithm should work fine. OPTIONAL: For those of you seeking an additional challenge, try implementing a heap-based version. The simpler approach, which should already give you a healthy speed-up, is to maintain relevant edges in a heap (with keys = edge costs). The superior approach stores the unprocessed vertices in the heap, as described in lecture. Note this requires a heap that supports deletions, and you'll probably need to maintain some kind of mapping between vertices and their positions in the heap.
=end
def prim(array, vertex_num)
  mstSet = []
  vertex_key = []
  vertex_last = vertex_num
  min_cost = 9999999999999
  (0..vertex_last - 1).each do |i|
    vertex_key[i] = min_cost
    mstSet[i] = false
  end
  vertex_key[0] = 0
  (0..vertex_last - 1).each do |x|
    u = find_min_edge(mstSet, vertex_key)
    mstSet[u] = true
    update_key(array, u, vertex_key, mstSet)
  end
  sum = 0
  (0..vertex_key.length-1).each do |i|
    sum += vertex_key[i]
  end
  return sum
end
def find_min_edge(mstSet, vertex_key)
  min_cost = 9999999999999
  min_index = -1
  (0..vertex_key.length-1).each do |i|
    if mstSet[i]==false && vertex_key[i] < min_cost
      min_cost = vertex_key[i]
      min_index = i
    end
  end
  return min_index
end
def update_key(array, u, vertex_key, mstSet)
  (1..array[u].length-1).each do |i|
    if mstSet[array[u][i][0]-1]==false && vertex_key[array[u][i][0]-1] > array[u][i][1]
      vertex_key[array[u][i][0]-1] = array[u][i][1]
    end
  end
end
def file_to_graph
  graph_list = []
  vertex_num = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/edges.txt','r') do |f|
    f.each_line do |line|
      array = line.gsub("\n"," ").split(" ")
      array.map! do |s|
        s.to_i
      end
      if array.length < 3
        vertex_num = array[0]
        (0..vertex_num -1).each do |i|
          graph_list[i] = [i+1]
        end
      else
       # vertex 1 -> vertex 2 and vertex 2 -> vertex 1 should have same edge cost
       graph_list[array[0]-1] << [ array[1],array[2] ]
       array[0], array[1] = array[1], array[0]
       graph_list[array[0]-1] << [ array[1],array[2] ]      
      end
    end
  end
  return graph_list, vertex_num
end

a, num = file_to_graph

#b = [ [1, [2, 4],[8, 8]], [2,[8,11],[3,8]], [3,[9,2],[4,7],[6,4]], [4,[5 ,9],[6 ,14]], [5,[6, 10]], [6,[7, 2]], [7,[8, 1],[9, 6]], [8,[9, 7]], [9,[8,7],[7,6],[3,2]]  ]

#e = [ [1, [2,4],[8,8] ],[2,[1,4],[3,8],[8,11] ],[ 3,[2,8],[9,2],[6,4],[4,7]],[4,[3,7],[6,14],[5,9] ],[5,[4,9],[6,10] ],[6, [7,2],[3,4],[4,14],[5,10] ],[7,[8,1],[9,6],[6,2]],[8,[1,8],[2,11],[9,7],[7,1]],[9,[8,7],[7,6],[3,2]] ]

#c = [ [1, [2, 2],[7,4]], [2,[3, 4],[4, 2],[7,6]], [3,[4,3],[2,4]] , [4,[5,5],[6,3],[2,2],[3,3]] , [5,[6,3],[8,4],[4,5]], [6,[7,5],[8,4],[5,3],[4,3]], [7,[9,2],[1, 4],[2, 6],[6,5]], [8,[9,3],[5,4],[6,4]] ,[9,[8,3],[7,2] ] ]

#d = [ [1, [2,2], [4,1]], [ 2,[1,2],[3,5],[4,3] ], [3,[2,5],[4,4]] , [4,[1,1],[2,3],[3,4]] ]

#f = [ [1,[2,50],[4,40]],[2,[3,40]], [3,[4,20],[5,30]], [4,[5,10]], [5] ] 

puts prim(a, num)



