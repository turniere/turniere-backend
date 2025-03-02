require 'benchmark'

def split_and_rotate(arr)
  midpoint = arr.length / 2
  arr[0...midpoint] + arr[midpoint..-1]
end

# Create a large array with 1 million entries
large_array = (1..1_000_000).to_a

# Run the operation 1000 times and calculate the average time
total_time = 0
iterations = 1000

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
