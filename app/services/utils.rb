# frozen_string_literal: true

class Utils
  def self.previous_power_of_two(number)
    return 0 if number.zero?

    exponent = Math.log2 number
    2**exponent.floor
  end

  def self.next_power_of_two(number)
    return 1 if number.zero?

    2 * previous_power_of_two(number)
  end

  def self.po2?(number)
    number.to_s(2).count('1') == 1
  end
end
