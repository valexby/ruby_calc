str = gets
str.delete!(' ')
str.delete!('_')
str.delete!("\n")

str.gsub!(/(plus|add|minus|multiply|divide|point|dot)/,
          'plus' => '+',
          'add' => '+',
          'minus' => '-',
          'multiply' => '*',
          'divide' => '/',
          'point' => '.',
          'dot' => '.')
puts(str)
p str.gsub!(/(-|\+|\*|\/)/) { |s| " #{s} " }
tokens = str.split(' ')
p tokens

is_complex = tokens.any? { |token| ['-', '*', '/'].include?(token) }
is_number = tokens.all? { |token| token.match(/^(\d*\.?\d+)|[-\+\*\/]$/) }
is_arrays = tokens.any? { |token| token.match(/^(\[(\d*\.?\d+)(,(\d*\.?\d+))*+\])|(\[\])$/) }
is_arrays &&= tokens.all? { |token| token.match(/^(\[(\d*\.?\d+)(,(\d*\.?\d+))*+\])|(\[\])|[\+]|(\d*\.?\d+)$/) }
puts "Error" if is_complex && !is_number
puts "Is array" if is_arrays
puts "Is string" if !is_complex && !is_arrays
puts "Is number" if is_number
