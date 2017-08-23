class Calc
  attr_reader :formatted, :result

  def calc(str)
    @result = nil
    tokens = to_tokens(str)
    is_complex, is_number, is_arrays = interpret(tokens)
    if is_complex && !is_number
      puts 'Bad input'
      return
    elsif !is_complex && !is_arrays
      str = proccess_strings(tokens)
    end
    @result = eval(str)
  end

  private

  OPERATORS = { 'plus' => '+',
                'add' => '+',
                'minus' => '-',
                'multiply' => '*',
                'divide' => '/',
                'point' => '.',
                'dot' => '.' }.freeze

  ARR_PATTERN = /^((\[(\d+(\.\d+)?)(,(\d+(\.\d+)?))*\])|(\[\]))$/
  ZXC = /^((\[(\d+(\.\d+)?)(,(\d+(\.\d+)?))*\])|(\[\])|\+|(\d+(\.\d+)?)|<<)$/
  NUMB_STR_PATTERN = %r{^((\d+(\.\d+)?)|([-\+\*\/]))$}

  def proccess_strings(tokens)
    tokens.map! do |token|
      token != '+' && token != '<<' ? "\"#{token}\"" : token
    end
    tokens.reduce(:+)
  end

  def to_tokens(str)
    str.delete!(' ')
    str.delete!('_')
    str.delete!("\n")

    str.gsub!(/(plus|add|minus|multiply|divide|point|dot)/, OPERATORS)
    str.gsub!(%r{(-|\+|\*|\/|<<)}) { |s| " #{s} " }
    @formatted = str
    str.split(' ')
  end

  def interpret(tokens)
    is_complex = tokens.any? { |token| ['-', '*', '/'].include?(token) }
    is_number = tokens.all? { |token| token.match(NUMB_STR_PATTERN) }
    is_arrays = tokens[0] =~ ARR_PATTERN
    is_arrays &&= tokens.all? { |token| token.match(ZXC) }
    p [is_complex, is_number, is_arrays]
  end
end

def main
  calc = Calc.new()
  command = ''
  while command != 'exit'
    command = gets
    calc.calc(command)
    puts "formatted: #{calc.formatted}\nresult: #{calc.result}"
  end
end

main
