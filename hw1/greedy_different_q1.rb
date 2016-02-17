=begin
  Question 1
In this programming problem and the next you'll code up the greedy algorithms from lecture 
for minimizing the weighted sum of completion times.. Download the text file here. 
This file describes a set of jobs with positive and integral weights and lengths. 
It has the format
[number_of_jobs]
[job_1_weight] [job_1_length]
[job_2_weight] [job_2_length]
...
For example, the third line of the file is "74 59", 
indicating that the second job has weight 74 and length 59. 
You should NOT assume that edge weights or lengths are distinct.
Your task in this problem is to run the greedy algorithm that
schedules jobs in decreasing order of the difference (weight - length). 
Recall from lecture that this algorithm is not always optimal. 
IMPORTANT: if two jobs have equal difference (weight - length), 
you should schedule the job with higher weight first. 
Beware: if you break ties in a different way, you are likely to get the wrong answer. 
You should report the sum of weighted completion times of the resulting schedule
 --- a positive integer --- in the box below.
ADVICE: If you get the wrong answer, try out some small test cases to debug your algorithm 
(and post your test cases to the discussion forum)!
=end
def greedy_diff
  sum = 0
  jobs_list = get_jobs1_diff
  # sort the job by the difference 
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
#generate joblist array with the job_weight minus job_length(the difference)
def get_jobs1_diff
  jobs_list = []
  i = 0
  File.open('/Users/chen-chouhsieh/Desktop/algorithms/algorithms2/jobs.txt','r') do |f|
    f.each_line do |line|
      array = line.gsub("\n"," ").split(" ")
      array.map! do |s|
        s.to_i
      end
      if array.length >=2
        jobs_list[i] = [array[0], array[1], array[0]-array[1]]
        i += 1
      end
    end
  end
  return jobs_list
end

#b = [[8 ,50],[74 ,59],[31, 73],[45, 79],[10, 10], [41, 66] ] 
puts greedy_diff


