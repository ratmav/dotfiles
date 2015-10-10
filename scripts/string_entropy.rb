require 'optparse'

OptionParser.new do |opts|
  opts.banner = 'Usage: string_entropy.rb "your_test_string"'
end.parse!

def entropy(s)
  counts = Hash.new(0.0)
  s.each_char { |c| counts[c] += 1 }
  leng = s.length

  counts.values.reduce(0) do |entropy, count|
    freq = count / leng
    entropy - freq * Math.log2(freq)
  end
end

puts entropy(ARGV.to_s) unless ARGV.empty?
