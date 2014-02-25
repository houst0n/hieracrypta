# vim: ft=ruby

require 'rake/clean'
require 'rake/testtask'
require 'rubygems'
require 'rubygems/package_task'
require 'cucumber'
require 'cucumber/rake/task'

spec = eval(File.read('hieracrypta.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*/*_test.rb']
end
