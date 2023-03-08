# -*- ruby -*-

require "rubygems"
require "bundler/gem_helper"

base_dir = File.join(File.dirname(__FILE__))

helper = Bundler::GemHelper.new(base_dir)
def helper.version_tag
  version
end

helper.install
spec = helper.gemspec

task default: :test

desc "Run tests"
task :test do
  ruby("test/run-test.rb")
end

desc "Generate an artifact for GitHub Pages"
task :pages do
  pages_dir = "_site"
  rm_rf(pages_dir)
  mkdir_p(pages_dir)

  require "cgi/util"
  require_relative "lib/datasets/lazy"
  File.open("#{pages_dir}/index.html", "w") do |index_html|
    index_html.puts(<<-HTML)
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Red Datasets</title>
    <style>
      table {
        margin-left: 20vw;
        min-width: 50%;
      }
      th {
        font-size: 30px;
        padding: 20px;
      }
      td {
        border-bottom: 1px solid #D9DCE0;
        padding: 20px;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <section>
      <h1>Red Datasets</h1>
      <table>
        <thead>
          <tr><th>Available datasets</th></tr>
        </thead>
        <tbody>
    HTML
    Datasets::LAZY_LOADER.constant_names.sort.each do |constant_name|
      index_html.puts(<<-HTML)
          <tr><td>#{CGI.escapeHTML("Datasets::#{constant_name}")}</td></tr>
      HTML
    end
    index_html.puts(<<-HTML)
        </tbody>
      </table>
    </section>
  </body>
</html>
    HTML
  end
end
