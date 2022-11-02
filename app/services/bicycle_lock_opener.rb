class BicycleLockOpener
   def initialize(wheels, start_combinaton, end_combination, exclude_combination)
    @wheels, @start_combinaton, @end_combination, @exclude_combination =
      wheels, start_combinaton, end_combination, exclude_combination

    @code = @start_combinaton.dup
    @history = @exclude_combination.dup
    init_values

    @wheel_iteration = []
    init_wheel_iteration
    @iteration_history = [@wheel_iteration.dup]
  end

  def self.unlock(wheels, start_combinaton, end_combination, exclude_combination)
    new(wheels, start_combinaton, end_combination, exclude_combination).unlock
  end

  def unlock
    calculate_combinations
    @code.blank? ? "There is no solution to these conditions" : @values
  end

  private

  attr_reader :wheels, :start_combinaton, :end_combination, :exclude_combination

  def init_values
    @values = [@start_combinaton.dup]
  end

  def init_wheel_iteration
    (0..wheels - 1).each do |wheel|
      @wheel_iteration[wheel] = set_iterator(end_combination[wheel], 5)
    end
  end

  def calculate_combinations
    while @code != end_combination
      if @code.blank?
        is_exit? ? break : update_iteration
      end
      success = false
      (wheels - 1).downto(0).each do |wheel|
      	test_code = set_test_code wheel
        if @code[wheel] == end_combination[wheel] || @history.include?(test_code)
          pop_values if !success && wheel == 0
          break if @code.blank? && is_exit?
          next
        end
        success = true
        set_codes test_code
      end
    end
  end

  def pop_values
    @values.pop
    @code = @values.last.dup
  end

  def set_codes(new_code)
    @code = new_code
    @values << @code.dup
    @history << @code.dup
  end

  def set_test_code(wheel)
    new_code = @code.dup
    new_code[wheel] = set_digit new_code[wheel], wheel
    new_code
  end

  def set_digit(digit, wheel)
  	new_digit = digit + @wheel_iteration[wheel]
    return 0 if new_digit > 9
  	new_digit < 0 ? 9 : new_digit
  end

  def is_exit?
    @iteration_history.count == 2 ** wheels
  end

  def update_iteration
    init_values
    @code = start_combinaton
    (wheels - 1).downto(0).each do |wheel|
      @wheel_iteration[wheel] = set_iterator(@wheel_iteration[wheel], 0)
      break unless @iteration_history.include? @wheel_iteration
      next
    end
    @iteration_history << @wheel_iteration.dup
  end

  def set_iterator(value, condition)
    value > condition ? -1 : 1
  end
end
