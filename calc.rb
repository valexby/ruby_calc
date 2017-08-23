def proccess_strings(tokens)
  tokens.map! do |token|
    token != '+' && token != '<<' ? "\"#{token}\"" : token
  end
  tokens.reduce(:+)
end

def calc(str)
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
  str.gsub!(/(-|\+|\*|\/|<<)/) { |s| " #{s} " }
  tokens = str.split(' ')

  is_complex = tokens.any? { |token| ['-', '*', '/'].include?(token) }
  is_number = tokens.all? { |token| token.match(/^((\d+(\.\d+)?)|([-\+\*\/]))$/) }
  is_arrays = tokens[0] =~ /^((\[(\d+(\.\d+)?)(,(\d+(\.\d+)?))*\])|(\[\]))$/
  is_arrays &&= tokens.all? { |token| token.match(/^((\[(\d+(\.\d+)?)(,(\d+(\.\d+)?))*\])|(\[\])|\+|(\d+(\.\d+)?)|<<)$/) }
  if is_complex && !is_number
    puts "Error"
    return nil
  end

  return eval(str) if is_arrays
  if !is_complex && !is_arrays
    p tokens
    str = proccess_strings(tokens)
    p str
    return eval(str)
  end

  return eval(str) if is_number
  p "Unexspected conditions"
  nil
end

loop do
  s = gets
  p calc(s)
end
