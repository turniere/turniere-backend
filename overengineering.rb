require 'benchmark'

def split_and_rotate_with_each_slice(arr)
  # Use each_slice to split the array into two parts
  parts = arr.each_slice(arr.length/2).to_a
  # Rotate the array by concatenating the back part with the front part
  parts[1] + parts[0]
end



# Create a large array with 1 million entries
large_array = (1..1_000_000).to_a

# test with small array 1, 2, 3, 4, 5, 6
# expected output: 3, 4, 5, 6, 1, 2
puts split_and_rotate_with_each_slice([1, 2, 3, 4, 5, 6])

# Run the operation 1000 times and calculate the average time
total_time = 0
iterations = 100

iterations.times do
  time_taken = Benchmark.realtime do
    split_and_rotate(large_array)
  end
  total_time += time_taken
  # shuffle the array to avoid caching
  large_array.shuffle!
end

average_time = total_time / iterations
puts "Average time taken over #{iterations} iterations: #{average_time} seconds"

iterations.times do
  time_taken = Benchmark.realtime do
    split_and_rotate_with_each_slice(large_array)
  end
  total_time += time_taken
  # shuffle the array to avoid caching
  large_array.shuffle!
end

average_time = total_time / iterations
puts "Average time taken with .each_slice over #{iterations} iterations: #{average_time} seconds"
