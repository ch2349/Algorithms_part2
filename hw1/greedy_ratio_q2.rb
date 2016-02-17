=begin
Question 2
For this problem, use the same data set as in the previous problem. 
Your task now is to run the greedy algorithm that schedules jobs (optimally) 
in decreasing order of the ratio (weight/length). In this algorithm, 
it does not matter how you break ties. You should report 
the sum of weighted completion times of the resulting schedule 
--- a positive integer --- in the box below.  
=end
def greedy_ratio
  sum = 0
  jobs_list = get_jobs1_ratio
  #jobs_list = get_jobs2_ratio(array)
  # sort the job by the ratio 
  jobs_sort = mergeSort(jobs_list)
  c = 0
  (jobs_sort.length-1).downto(0).each do |i|
    c += jobs_sort[i][1]
    sum = sum + jobs_sort[i][0]*c
  end
  return sum
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
    if array_1[i][2] <= array_2[j][2]
  	  if array_1[i][2]==array_2[j][2]
  	    if array_1[i][0] < 	array_2[j][0]
  	      array << array_1[i]
  	      i += 1
  	    else
  	      array << array_2[j]
  	      j += 1 
  	    end
  	  else
  	    array << array_1[i]
        i += 1
      end
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

def get_jobs1_ratio
  jobs_list = []
  i = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/jobs.txt','r') do |f|
    f.each_line do |line|
      array = line.gsub("\n"," ").split(" ")
      array.map! do |s|
        s.to_i
      end
      if array.length >=2
        jobs_list[i] = [array[0], array[1], array[0].to_f/array[1].to_f ]
        i += 1
      end
    end
  end
  return jobs_list
end

#def get_jobs2_ratio(array)
#  job_list = []
#  (0..array.length-1).each do |i|
#    job_list[i] = [array[i][0], array[i][1], array[i][0].to_f/array[i][1].to_f ]
#  end
#  return job_list
#end

#b = [[8 ,50],[74 ,59],[31, 73],[45, 79],[10, 10], [41, 66] ] 
puts greedy_ratio


