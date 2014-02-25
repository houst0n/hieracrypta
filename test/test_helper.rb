path = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'minitest/autorun'
require 'mocha/setup'
require 'hieracrypta'

require 'local_reporter'
Minitest::Reporters.use! Minitest::Reporters::LocalReporter.new
