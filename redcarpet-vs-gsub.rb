# Original string...: Hello **world**, _talic_, `code`, and some non-formatted text.
# Markdown..........: <p>Hello <strong>world</strong>, <em>talic</em>, <code>code</code>, and some non-formatted text.</p>
# Markdown (no p)...: Hello <strong>world</strong>, <em>talic</em>, <code>code</code>, and some non-formatted text.
# Gsub..............: Hello <strong>world</strong>, <em>talic</em>, <code>code</code>, and some non-formatted text.
#
#                       user     system      total        real
# markdown          0.140000   0.000000   0.140000 (  0.132617)
# markdown (no p)   0.760000   0.000000   0.760000 (  0.768906)
# gsub              0.980000   0.010000   0.990000 (  0.983499)s

require 'bundler/setup'
require 'redcarpet'
require 'benchmark'

string = "Hello **world**, _talic_, `code`, and some non-formatted text."

class GsubMarkdown
  def render(string)
    string = string.dup
    string.gsub!(/\*\*(.*)\*\*/) { "<strong>#{$1}</strong>" }
    string.gsub!(/\_(.*)\_/) { "<em>#{$1}</em>" }
    string.gsub!(/\`(.*)\`/) { "<code>#{$1}</code>" }
    string
  end
end

class RenderWithoutWrap < Redcarpet::Render::HTML
  def postprocess(full_document)
    Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(full_document)[1] rescue full_document
  end
end

markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
markdown_without_p = Redcarpet::Markdown.new(RenderWithoutWrap)
gsub_markdown = GsubMarkdown.new

puts "Original string...: #{string}"
puts "Markdown..........: #{markdown.render(string)}"
puts "Markdown (no p)...: #{markdown_without_p.render(string)}"
puts "Gsub..............: #{gsub_markdown.render(string)}"
puts

n = 100000
Benchmark.bm(15) do |x|
  x.report("markdown       ") { n.times { markdown.render(string) } }
  x.report("markdown (no p)") { n.times { markdown_without_p.render(string) } }
  x.report("gsub           ")     { n.times { gsub_markdown.render(string) } }
end
