=begin
Question 1
In this assignment you will implement one or more algorithms for the all-pairs shortest-path problem. 
Here are data files describing three graphs: graph #1; graph #2; graph #3.
The first line indicates the number of vertices and edges, respectively. 
Each subsequent line describes an edge (the first two numbers are its tail and head, respectively)
and its length (the third number). NOTE: some of the edge lengths are negative. 
NOTE: These graphs may or may not have negative-cost cycles.
Your task is to compute the "shortest shortest path". 
Precisely, you must first identify which, if any, of the three graphs have no negative cycles.
For each such graph, you should compute all-pairs shortest paths and remember the smallest one
(i.e., compute minu,v∈Vd(u,v), where d(u,v) denotes the shortest-path distance from u to v).
If each of the three graphs has a negative-cost cycle, then enter "NULL" in the box below. 
If exactly one graph has no negative-cost cycles,
then enter the length of its shortest shortest path in the box below.
If two or more of the graphs have no negative-cost cycles,
then enter the smallest of the lengths of their shortest shortest paths in the box below.
OPTIONAL: You can use whatever algorithm you like to solve this question.
If you have extra time, try comparing the performance of different all-pairs shortest-path algorithms! 
=end
def johnson(array, array_n_0, total_vertex)
  result = []
  dist_factor = bellmond_ford(array, total_vertex )
  if dist_factor == 'negative cycle'
  	return 'negative cycle'
  end
  array_new = reweight_graph(array_n_0, dist_factor)
  graph_new = array_to_graph(array_new, total_vertex - 1)
  last_vertex = total_vertex - 1
  # do Dijksra’s algorithm for each vertex 
  (1..last_vertex).each do |i|
    result << diks(graph_new, i, last_vertex, dist_factor)
  end
  min = result[0]
  (1..result.length - 1).each do |i|
    if result[i] < min
      min = result[i]
    end 
  end
  return min
end

def bellmond_ford(array, vertex_num)
  dist = []
  inf = 999999999
  (0..vertex_num - 1).each do |i|
    dist[i] = inf
  end
  dist[0] = 0
  # do V-1 times for each edges relax the vertex score
  (1..vertex_num - 2).each do |i|
    (0..array.length - 1 ).each do |j|
      u = array[j][0]
      v = array[j][1]
      weight = array[j][2]
      if (dist[u] + weight < dist[v]) && dist[u]!= inf
        dist[v] = dist[u] + weight   
      end 
    end
  end
  # if addtional loop will change the result then there is a negative cycle
  (0..array.length - 1).each do |j|
    u = array[j][0]
    v = array[j][1]
    weight = array[j][2]
    if dist[u] + weight < dist[v] && dist[u]!= inf
      return 'negative cycle'
    end 
  end
  return dist
end
# transform the array to graph for Dijksra’s algorithm
def array_to_graph(array, last_vertex)
  graph_new = []
  (0..last_vertex - 1).each do|i|
    graph_new[i] = [i+1]    
  end
  (0..array.length - 1).each do |j|
  	graph_new[array[j][0] - 1] << [ array[j][1], array[j][2] ]
  end
  return graph_new
end

# reweight the original graph by dist
def reweight_graph(array, dist)
  graph_new = []
  (0..array.length-1).each do |i|
    graph_new << [ array[i][0], array[i][1], (array[i][2] + dist[array[i][0]] - dist[array[i][1]]) ]
  end
  return graph_new
end

def diks(array, vertex, total_vertex, dist_factor)
  min_heap = []
  inf = 999999999
  (0..total_vertex - 1).each do |i|
    # [vertex, dist] at vertex -1 position
    min_heap[i] = [i+1, inf]
  end
  hash_table = []
  (0..total_vertex - 1).each do |i|
    # [ vertex , minheap position] at vertex -1 position
    hash_table[i] = [i+1, i ]
  end
  dist = []
  (0..total_vertex - 1).each do |i|
    dist[i] = inf
  end
  dist[vertex - 1] = 0
  decrease_dis(min_heap, hash_table, vertex, 0)
  0.upto(array.count-1) do |i|
    root = extract_min(min_heap, hash_table)
    u = root[0]
    (1..array[u - 1].length - 1).each do |j|
      if isInMinHeap(min_heap, hash_table, array[u - 1][j][0])==true && ( dist[u - 1] + array[u - 1][j][1] ) < dist[array[u - 1][j][0] - 1]
        dist[array[u - 1][j][0] - 1] = dist[u - 1] + array[u - 1][j][1]
        decrease_dis(min_heap, hash_table, array[u - 1][j][0], dist[u - 1] + array[u - 1][j][1])
      end 
    end
  end
  return find_min(dist, vertex, dist_factor)
end
# the Dijksra’s algorithm run on reweight graph and need to transfer back to original graph to get 
# the original edge weight
def find_min(dist, vertex, dist_factor)
  dist_final = []
  (0..dist.length - 1).each do |i|
      dist_final[i] = dist[i] - dist_factor[vertex] + dist_factor[i+1]
  end
  min_dist = dist_final[0]  
  (1..dist_final.length - 1).each do |i|
    if dist_final[i] < min_dist
      min_dist = dist_final[i]
    end 
  end
  return min_dist
end
  
def decrease_dis(min_heap, hash_table, vertex, dist)
  # vertex position in minheap
  i = hash_table[vertex - 1][1]
  # update vertex's minheap dist
  min_heap[i][1] = dist
  # travel up the minheap if parent > child && not at the root
  while ( i!=0 && (min_heap[i][1] < min_heap[(i - 1)/2][1]) )
    hash_table[min_heap[i][0] - 1][1] = (i - 1)/2
    hash_table[min_heap[(i - 1)/2][0] - 1][1] = i
    min_heap[i], min_heap[(i - 1)/2] = min_heap[(i - 1)/2], min_heap[i]
    i = (i - 1)/2
  end
end

def extract_min(min_heap, hash_table)
  if min_heap.length==0
    return 'null'
  end 
  root = []
  new_root = []
  root = min_heap[0]
  new_root = min_heap.last
  hash_table[min_heap[0][0] - 1][1] = min_heap.length + 1
  min_heap.delete_at(0)
  min_heap.delete_at(-1)
  hash_table[new_root[0] - 1][1] = 0 
  min_heap.unshift(new_root)
  heapify(min_heap, hash_table, 0)
  return root
end
# heapify means balance the min_heap
def heapify(min_heap, hash_table, index)
  smallest = index
  left_child = 2*index + 1
  right_child = 2*index + 2
  if (left_child < min_heap.length)&&(min_heap[left_child][1] < min_heap[smallest][1])
    smallest = left_child 
  end
  if (right_child < min_heap.length)&&(min_heap[right_child][1] < min_heap[smallest][1])
    smallest = right_child
  end
  if smallest!= index
    hash_table[min_heap[index][0] - 1][1] = smallest
    hash_table[min_heap[smallest][0] - 1][1] = index
    min_heap[smallest], min_heap[index] = min_heap[index], min_heap[smallest]
    heapify(min_heap, hash_table, smallest)
  end
end

def isInMinHeap(min_heap, hash_table, v)
  if hash_table[v - 1][1] < min_heap.length
    return true
  else
    return false
  end
end

def array_graph(array)
  c = []
  b = []
  (0..array.length-1).each do |i|
    c << array[i]
    b << array[i]
  end
  total_vertex = c[0][0]
  c.delete_at(0)
  b.delete_at(0)
  (1..total_vertex).each do |i|
    c.unshift([0, i, 0])
  end
  return total_vertex + 1, c, b
end

def file_to_array
  c = []
  b = []
  total_vertex = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/g3.txt','r') do |f|
    f.each_line do |line|
      array = line.gsub("\n"," ").split(" ")
      array.map! do |s|
        s.to_i
      end
      c << array
      b << array
    end
    total_vertex = c[0][0]
  end
  c.delete_at(0)
  b.delete_at(0)
  (1..total_vertex).each do |i|
    c.unshift([0, i, 0])
  end
  # add additional 0 for bellmond ford
  return total_vertex + 1, c, b
end
vertex_num, array_with_0, array_no_0 = file_to_array

#d = [[6, 5],[1, 6, -10],[1, 2, -5],[2, 3, 1],[3, 4, 1],[4, 5, -10000]]
#e= [[6, 7],[1, 2 ,-2],[2, 3, -1],[3, 1 ,4],[3, 4 ,2],[3, 5 ,-3],[6, 4 ,1],[6, 5 ,-4]]
#f= [[5 ,5],[1 ,2 ,-1],[2, 3, -2],[3, 4, -3],[4, 1 ,4],[5 ,1 ,3]]
#g = [[6,5],[1,2,-2],[2,3,-1],[3,1,4],[3,4,2],[3,5,-3],[6,4,1],[6,5,-4]]
#vertex_num, array_with_0, array_no_0 = array_graph(f)
puts johnson(array_with_0, array_no_0 ,vertex_num)

