def papa_sat_try(array, vertex_num)
  hash_table, array_table, vertex_num = create_hash_table(array)
  array_pre, _hash_table_pre = preprocess_in_hash_table(hash_table, array_table)
  hash_map, array_map, vertex_num = create_hash_table(array_pre)
  (0..array_map.length - 1).each do |i|
    array_map[i] << []
  end
  Math.log2(vertex_num).to_i.times do |_i|
    assign_boolean(hash_map, array_map)
    2 * (vertex_num**2).times do |_j|
      position = check_boolean(hash_map, array_map)
      return 'satisfiable' if position == 'satisfiable'
      flip_boolean(position, hash_map, array_map)
    end
  end
  'unsatisfiable'
end

def assign_boolean(hash_table, array_table)
  (0..hash_table.length - 1).each do |i|
    next if hash_table[i] == [] || hash_table[i].nil?
    value = [true, false].sample
    vertex = hash_table[i][0][1]
    (0..hash_table[i].length - 1).each do |j|
      if hash_table[i][j][1] == vertex
        hash_table[i][j] << value
        if array_table[hash_table[i][j][0]][0] == hash_table[i][j][1]
          array_table[hash_table[i][j][0]][2][0] = value
        elsif array_table[hash_table[i][j][0]][1] == hash_table[i][j][1]
          array_table[hash_table[i][j][0]][2][1] = value
        end
      elsif hash_table[i][j][1] == -vertex
        hash_table[i][j] << !value
        if array_table[hash_table[i][j][0]][0] == hash_table[i][j][1]
          array_table[hash_table[i][j][0]][2][0] = !value
        elsif array_table[hash_table[i][j][0]][1] == hash_table[i][j][1]
          array_table[hash_table[i][j][0]][2][1] = !value
        end
      end
    end
  end
end

def check_boolean(_hash_table, array_table)
  set = []
  (0..array_table.length - 1).each do |i|
    boolean = array_table[i][2][0] || array_table[i][2][1]
    set << i if boolean == false
  end
  return 'satisfiable' if set.empty?
  set.sample
end

def flip_boolean(position, hash_table, array_table)
  choose = [0, 1].sample
  vertex = nil
  boolean = nil
  array_table[position][2][choose] = if array_table[position][2][choose] == true
                                       false
                                     else
                                       true
                                     end
  vertex = array_table[position][choose]
  boolean = array_table[position][2][choose]
  (0..hash_table[vertex.abs - 1].length - 1).each do |i|
    if hash_table[vertex.abs - 1][i][1] == vertex
      hash_table[vertex.abs - 1][i][2] = boolean
      if array_table[hash_table[vertex.abs - 1][i][0]][0] == vertex
        array_table[hash_table[vertex.abs - 1][i][0]][2][0] = boolean
      elsif array_table[hash_table[vertex.abs - 1][i][0]][1] == vertex
        array_table[hash_table[vertex.abs - 1][i][0]][2][1] = boolean
      end
    elsif hash_table[vertex.abs - 1][i][1] == -vertex
      hash_table[vertex.abs - 1][i][2] = !boolean
      if array_table[hash_table[vertex.abs - 1][i][0]][0] == -vertex
        array_table[hash_table[vertex.abs - 1][i][0]][2][0] = !boolean
      elsif array_table[hash_table[vertex.abs - 1][i][0]][1] == -vertex
        array_table[hash_table[vertex.abs - 1][i][0]][2][1] = !boolean
      end
    end
  end
end

def create_hash_table(array)
  hash_table = []
  array_table = []
  count = []
  (0..array.length - 1).each do |i|
    hash_table[array[i][0].abs - 1] = [] if hash_table[array[i][0].abs - 1].nil?
    hash_table[array[i][1].abs - 1] = [] if hash_table[array[i][1].abs - 1].nil?
    array_table[i] = [] if array_table[i].nil?
    hash_table[array[i][0].abs - 1] << [i, array[i][0]]
    hash_table[array[i][1].abs - 1] << [i, array[i][1]]
    array_table[i] = array[i].dup
    count << array[i][0]
    count << array[i][1]
  end
  vertex_num = count.uniq.length
  [hash_table, array_table, vertex_num]
end

# Basically, I looked for any number that did not appear
# as both positive and negative, and then removed any clause
# that contained that number. Removing those clauses may free up other numbers,
# so loop through this until no more clauses can be eliminated -
# then run Papadimitriou's algorithm on just the remaining clauses.
# For example, if the clauses are:
# 1 2
# -2 1
# 2 3
# 2 -3
# Then, since 1 only appears as positive,
# we can set it's value to True (or False if it had only appeared as negative),
# and any clause that it appears in will always be True,
# so we can eliminate them. That leaves us with:
# 2 3
# 2 -3
# Now, 2 only appears as positive, so we can set it to True
# and knock out both the remaining clauses. Using this technique,
#  I never had more than ~300 significant clauses to process.
def preprocess_in_hash_table(hash_table, array_table)
  singular_still = true
  while singular_still == true
    singular_still = false
    (0..hash_table.length - 1).each do |i|
      next if hash_table[i].nil? || hash_table[i] == []
      hash_table[i].delete([])
      if hash_table[i].length == 1 && hash_table[i] != []
        singular_still = true
        delete_hash_singular(array_table, [hash_table[i][0][0]], hash_table[i][0][1], hash_table)
      end
      next unless hash_table[i].length > 1
      set = []
      row = []
      (0..hash_table[i].length - 1).each do |j|
        set << hash_table[i][j][1]
        row << hash_table[i][j][0]
      end
      set.uniq!
      if set.length == 1
        singular_still = true
        delete_hash_singular(array_table, row, set[0], hash_table)
      end
    end
  end
  array_table.delete([])
  [array_table, hash_table]
end

def delete_hash_singular(array_table, row, vertex, hash_table)
  vertex_delete = 0
  (0..row.length - 1).each do |x|
    if array_table[row[x]][0].abs != vertex.abs
      vertex_delete = array_table[row[x]][0].abs
    elsif array_table[row[x]][1].abs != vertex.abs
      vertex_delete = array_table[row[x]][1].abs
    end
    (0..hash_table[vertex_delete - 1].length - 1).each do |i|
      if hash_table[vertex_delete - 1][i][0] == row[x]
        hash_table[vertex_delete - 1][i] = []
      end
    end
  end
  hash_table[vertex.abs - 1] = []
  (0..row.length - 1).each do |i|
    array_table[row[i]] = []
  end
end

def file_to_array
  c = []
  total_vertex = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/2sat1.txt', 'r') do |f|
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
puts papa_sat_try(z, total_vertex)
