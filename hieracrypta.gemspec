# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','hieracrypta','VERSION.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'hieracrypta'
  s.version = Hieracrypta::VERSION
  s.authors = ['Neil Houston']
  s.email = ['neil.a.houston@gmail.com']
  s.homepage = 'https://github.com/houst0n/hieracrypta'
  s.platform = Gem::Platform::RUBY
  s.summary = 'serve gpg encrypted secrets to your puppet nodes'
  s.description = 'A simple webservice for serving encrypted secrets'

  # Add your other files here if you make them
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)

  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'hieracrypta'

  s.add_development_dependency('rack-test', '0.6.2')
  s.add_development_dependency('cucumber', '>0')
  s.add_development_dependency('gli', '2.9.0')
  s.add_development_dependency('gpgme', '2.0.2')
  s.add_development_dependency('rake', '10.1.1')
  s.add_development_dependency('sinatra', '1.4.4')
  s.add_development_dependency('json', '1.8.1')

  s.add_runtime_dependency('rugged', '0.19.0')
  s.add_runtime_dependency('gli', '2.9.0')
  s.add_runtime_dependency('gpgme', '2.0.2')
  s.add_runtime_dependency('sinatra', '1.4.4')
end

