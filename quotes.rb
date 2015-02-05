#                    user     system      total        real
# double         3.040000   0.010000   3.050000 (  3.050819)
# single         3.030000   0.000000   3.030000 (  3.042471)

require 'benchmark'

n = 5000000

Benchmark.bm(12) do |x|

  x.report('double') do
    n.times { "Hello world!" == "Hello world!" }
  end

  x.report('single') do
    n.times { 'Hello world!' == 'Hello world!' }
  end

end

puts
