def generate_sequence(length)
  result = []
  length.to_i.times { result << 10000 + (rand * 10000).to_i }
  result
end