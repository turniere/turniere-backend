# frozen_string_literal: true

class Utils
  # Calculates the previous power of 2 given a number
  #
  # @param number [Integer] the number to generate the previous power of 2 from
  # @return [Array] previous power of two
  def self.previous_power_of_two(number)
    return 0 if number.zero?

    exponent = Math.log2 number
    2**exponent.floor
  end

  # Calculates the next power of 2 given a number
  #
  # @param number [Integer] the number to generate the next power of 2 from
  # @return [Array] next power of two
  def self.next_power_of_two(number)
    return 1 if number.zero?

    2 * previous_power_of_two(number)
  end

  # Calculates if a number is a power of 2
  #
  # @param number [Integer] the number to check
  # @return [Boolean] is the number a power of 2?
  def self.po2?(number)
    number.to_s(2).count('1') == 1
  end

  # split the array in half and place the second half at the beginning
  # e.g. [1, 2, 3, 4, 5, 6] to [4, 5, 6, 1, 2, 3]
  def split_and_rotate(array)
    # handle the case where the array has an odd number of elements
    middle_element = []
    if array.length.odd?
      # pop the last element and place it in the middle
      middle_element = [array.pop]
    end
    mid = array.length / 2
    array[mid..-1] + middle_element + array[0..mid]
  end
end
