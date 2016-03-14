# "so if u is False, then v must be True."
# Stated as an implication, this is -u => v
# This says that if not-u is true (ie. if u is false), then v must be true.
# "same, if v is False, then u must be true."
# Stated as an implication, this is -v => u
# This says that if not-v is true (ie. if v is false), then u must be true.
# When we use the SCC approach,
# what we're doing is constructing an implication graph,
# which means each directed edge of the graph corresponds to one
# of these implication relationships between variables
# - cases where choosing a truth value for some variable
# forces us to assign a corresponding value to other variables
# (to satisfy the clauses in which they appear).
# (it could be that the variable u is under-constrained, and can arbitrarily
# take either true or false values in a satisfying assignment,
# as long as v is true. In this case,
# there won't be an implication path from v to -u,
# and they won't be in the same strongly connected component)
# "If s is assigned a value of True,
# then u must also be assigned a value of True."
# If u is assigned a value of True,
# then v must be assigned a value of False" (ie. ~v is True)
# if v is assigned a value of False,
# then t must be assigned a value of False" (ie ~t is True)
# Putting it all together, if s = true, then u = true, v = false, and t = false.
# However, if s = false,
# we can't conclude anything about u from just the implication chain shown here.
# If this implication chain continues in a circle (or SCC),
# then if any term in the loop
# (be it a variable or a negation) is True, they all must be.
# This is where the contradiction-detecting power
# of the SCC approach comes from.
# If both s and ~s are in the same SCC,
# then there is no way to assign a truth value
# to s without creating a contradiction.
# If s is true, that implies ~s is true, meaning s is false.
# If s is false, that makes ~s true, which implies s is true.
# Both ways we get a contradiction.@t = 0
@t = 0
@stack = []
@finished = []
def two_sat_scc(array, vertex_num)
  graph_list = generate_vertex_graph(array, vertex_num)
  dfs_iterative(graph_list, vertex_num, false, [])
  array_finished = array_rename_with_finish_time_rev(graph_list)
  @t = 0
  @stack.clear
  finished_v = []
  (0..@finished.length - 1).each do |i|
    finished_v << @finished[i]
  end
  @finished.clear
  dfs_iterative(array_finished, vertex_num, true, finished_v)
end

def generate_vertex_graph(arrays, vertex_num)
  graph_list = []
  total_vertex = 2 * vertex_num
  (0..total_vertex - 1).each do |i|
    graph_list[i] = []
  end
  arrays.each do |array|
    if array[0] > 0 && array[1] > 0
      graph_list[array[0] + vertex_num - 1] << [array[0] + vertex_num, array[1]]
      graph_list[array[1] + vertex_num - 1] << [array[1] + vertex_num, array[0]]
    elsif  array[0] > 0 && array[1] < 0
      graph_list[array[0] + vertex_num - 1] << [array[0] + vertex_num, -array[1] + vertex_num]
      graph_list[-array[1] - 1] << [-array[1], array[0]]
    elsif  array[0] < 0 && array[1] > 0
      graph_list[-array[0] - 1] << [-array[0], array[1]]
      graph_list[array[1] + vertex_num - 1] << [array[1] + vertex_num, -array[0] + vertex_num]
    else
      graph_list[-array[0] - 1] << [-array[0], -array[1] + vertex_num]
      graph_list[-array[1] - 1] << [-array[1], -array[0] + vertex_num]
    end
  end
  graph_list
end

def dfs_iterative(array, vertex_num, scc, finished_array)
  check = []
  visited = []
  total_vertex = 2 * vertex_num
  (0..total_vertex - 1).each do |i|
    visited[i] = false
  end
  finished_vertex = []
  (0..total_vertex - 1).each do |i|
    finished_vertex[i] = false
  end
  total_vertex.downto(1).each do |vertex|
    @stack << vertex
    while @stack.count != 0
      vertex_i = @stack.pop
      if !visited[vertex_i - 1]
        visited[vertex_i - 1] = true
        check << vertex_i if scc == true
        @stack << vertex_i
        (0..array[vertex_i - 1].length - 1).each do |i|
          unless visited[array[vertex_i - 1][i][1] - 1]
            @stack << array[vertex_i - 1][i][1]
          end
        end
      elsif !finished_vertex[vertex_i - 1]
        finished_vertex[vertex_i - 1] = true
        @t += 1
        @finished[vertex_i - 1] = @t
      end
    end
    if scc == true && check != [] && check.length > 1
      group = []
      negative = []
      positive = []
      (0..check.length - 1).each do |i|
        (0..finished_array.length - 1).each do |j|
          next unless finished_array[j] == check[i]
          group << j + 1
          if (j + 1) > vertex_num
            negative << j + 1
          else
            positive << j + 1
          end
        end
      end
      if negative != [] && positive != []
        (0..positive.length - 1).each do |i|
          (0..negative.length - 1).each do |j|
            return 'no clause' if positive[i] + vertex_num == negative[j]
          end
        end
      end
    end
    check = []
  end
  return 'yes clause' if scc == true
end

def array_rename_with_finish_time_rev(graph_list)
  graph_list_new = []
  (0..graph_list.length - 1).each do |i|
    graph_list_new[i] = []
  end
  graph_list.each do |list|
    next if list == []
    a = []
    (0..list.length - 1).each do |i|
      a = [@finished[list[i][0] - 1], @finished[list[i][1] - 1]]
      a[0], a[1] = a[1], a[0]
      graph_list_new[a[0] - 1] << a
    end
  end
  graph_list_new
end

def file_to_array
  c = []
  total_vertex = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/2sat6.txt', 'r') do |f|
    f.each_line do |line|
      array = line.tr("\n", ' ').split(' ')
      array.map!(&:to_i)
      c << array
    end
    total_vertex = c[0][0]
  end
  c.delete_at(0)
  [total_vertex, c]
end
total_vertex, z = file_to_array
puts two_sat_scc(z, total_vertex)
