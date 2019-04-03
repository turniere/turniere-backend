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
end
