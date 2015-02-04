#
# This benchmark compares various different ways to determine
# the fastest way to see if a string beings with another string.
#
#                                      user     system      total        real
# string =~ /\Aapple\//            1.190000   0.000000   1.190000 (  1.196396)
# /\Aapple/.match(string)          4.490000   0.060000   4.550000 (  4.565866)
# string.start_with?("apple/")     0.840000   0.000000   0.840000 (  0.841078)
# string[0,6] == 'apple/'          1.160000   0.000000   1.160000 (  1.166968)

require 'benchmark'

string = "apple/fruit/banana/vegetable"
n = 5000000

Benchmark.bm(30) do |x|
  x.report('string =~ /\Aapple\//') do
    n.times { string =~ /\Aapple\// }
  end

  x.report('/\Aapple/.match(string)') do
    n.times { /\Aapple/.match(string) }
  end

  x.report('string.start_with?("apple/")') do
    n.times { string.start_with?('apple/') }
  end

  x.report("string[0,6] == 'apple/'") do
    n.times { string[0,6] == 'apple/' }
  end

end

puts
