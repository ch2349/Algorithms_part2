require 'prime'
def tsp(array, vertex_num)
  start= Time.now
  result = []
  (0..1).each do |i|
    result[i] = []
  end
  current = 0
  dis = calculate_dis(array)
  vertex_set_binary = set_combination(vertex_num - 1, 1)
  result[1 - current][0] = [0]
  (0..vertex_set_binary.length - 1).each do |i|
    result[1 - current][0][i] = dis[0][i + 2][1]
  end
  (1..vertex_num - 2).each do |i|
    puts i
    first = ''
    i.times do |z|
      first << '1'
    end
    first_int = first.to_i(2)
    through_set_current = first_int
    while through_set_current < 2**(vertex_num - 1)
      result[current][through_set_current] = []
      (0..vertex_set_binary.length - 1).each do |k|
        if vertex_set_binary[k] & through_set_current == 0
          min_heap = []
          position = 1
          bit = '%0*b' % [vertex_num - 1, through_set_current] 
          (bit.length - 1).downto(0) do |x|
            if bit[x] == '1'
              bit_change = bit.dup
              bit_change[-position] = '0'
              pre = result[1 - current][bit_change.to_i(2)][position - 1]
              add_heap(min_heap, dis[position][k + 2][1] + pre)
            end
            position += 1
          end
          result[current][through_set_current][k] = min_heap[0]
        else
          result[current][through_set_current][k] = nil
        end
      end 
      if through_set_current < 2**(vertex_num - 1)
        through_set_current = hakmemItem175(through_set_current)
      end
    end
    result[1 - current] = []
    current = 1 - current
  end
  through_set_current = set_combination(vertex_num - 1, vertex_num - 1)
  min_heap_final = []
  position = 1
  bit = '%0*b' % [vertex_num - 1, through_set_current[0]]
  (bit.length - 1).downto(0) do |x|
    if bit[x] == '1'
      bit_change = bit.dup
      bit_change[-position] = '0'
      pre = 0
      pre = result[1 - current][bit_change.to_i(2)][position - 1]
      add_heap(min_heap_final, dis[position][1][1] + pre)
    end
    position += 1
  end
  finish = Time.now
  puts finish - start
  return min_heap_final[0]
end

# tranform '000000000000000000000011' to [1,2]
def city_set(set, n)
  visit = []
  city = '%0*b' % [n, set]
  k = 1 
  (city.length - 1).downto(0) do |i|
    if city[i] == '1'
      visit << k  
    end
    k += 1
  end
  return visit
end
# create set '100000...','010000..','110000..','1010000'
def set_combination(n, i)
  first = ''
  i.times do |i|
    first << '1'
  end
  first_int = first.to_i(2)
  set_combin = [first_int]
  if i > 0
    set_size = n_choose_k(n, i)
    (1..set_size - 1).each do |i|
      set_combin[i] = hakmemItem175(set_combin[i - 1])
    end
  end
  return set_combin
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

def check_prime(value)
  if Prime.prime?(value)
    return value
  else
    check_prime(value + 1)
  end
end

def n_choose_k(n, k)
  # numerator = n*(n-1)*(n-2)* .....(n-(k-1))
  # denumerator = k*(k-1)*(k-2)......1
  numerator = n
  denumerator = k
  (1..k - 1).each do |i|
    numerator = numerator*(n - i)
  end
  (1..k - 1).each do |i|
    denumerator = denumerator*(k - i)
  end
  n_k = numerator / denumerator
  return n_k
end

def add_heap(min_heap, new_item)
  min_heap << new_item
  bubble_up(min_heap, min_heap.length - 1)
end

def bubble_up(min_heap, index)
  # travel up the minheap if parent > child && not at the root
  while (index != 0 && min_heap[index] < min_heap[(index - 1)/2])
    min_heap[index], min_heap[(index - 1)/2] = min_heap[(index - 1)/2], min_heap[index]
    index = (index - 1)/2
  end
end

def create_hash_table(set_digit, set)
  hash_table = []
  hash_size = check_prime(set.length)
  (0..hash_size - 1).each do |i|
    hash_table[i] = []
  end
  (0..set.length - 1).each do |i|
    index = set[i]%hash_size
    hash_table[index] << [set[i], i]
  end
  return hash_table, hash_size
end

def calculate_dis(array)
  dis = []
  (0..array.length-1).each do |i|
    dis[i] = [i]
    (0..array.length-1).each do |j|
      dis[i] << [j, Math.sqrt((array[i][0] - array[j][0])**2 + (array[i][1] - array[j][1])**2)]
    end
  end 
  return dis
end

a = [[0, 0],[0, 2],[0, 4],[0, 6]]

c = [[0 ,0],[0 ,1],[0 ,2],[0 ,3],[0 ,4],[1 ,4],[1, 3],[1, 2],[1, 1],[1, 0]]

r = [ [0,1], [0,2], [0,4],[0,8] ]
g = [[0.328521, 0.354889],[0.832 ,0.832126],[0.680803, 0.865528],[0.734854, 0.38191],[0.14439, 0.985427],[0.90997, 0.587277],[0.408464, 0.136019],[0.896868 ,0.916344],[0.991904 ,0.383134],[0.451197, 0.741267],[0.825205 ,0.761446],[0.421804, 0.0374936],[0.332503 ,0.26436],[0.107117 ,0.51559],[0.845227 ,0.21359],[0.880095, 0.593086],[0.454773 ,0.834355],[0.7464 ,0.363176]]

def file_to_array
  c= []
  total_vertex = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/tsp.txt','r') do |f|
    f.each_line do |line|
      array = line.gsub("\n"," ").split(' ')
      array.map! do |s|
        s.to_f
      end
      c << array
    end
    total_vertex = c[0][0].to_i
  end
  c.delete_at(0)
  return total_vertex, c
end
total_vertex, d = file_to_array
puts tsp(d, total_vertex)
