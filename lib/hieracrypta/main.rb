#!/usr/bin/env ruby
require 'gli'

module Hieracrypta
  class Main
    include GLI::App

    def initialize(argv,
                   stdin  = STDIN,
                   stdout = STDOUT,
                   stderr = STDERR,
                   kernel = Kernel)
      @argv, @kernel = argv, kernel
      @stdin, @stdout, @stderr = stdin, stdout, stderr
      $stdin, $stdout, $stderr = stdin, stdout, stderr
    end


    def execute!
      program_desc "Serve gpg encrypted secrets to your puppet nodes"
      version Hieracrypta::VERSION

      switch [:v, :verbose], :desc => "Be verbose"

      desc 'Start the service'
      command :start do |c|
        c.action do |global_options, options, args|
          Hieracrypta::WebService.run!
        end
      end

      pre do |global,command,options,args|
        puts "Executing #{command.name}" if global[:v]
        true
      end

      post do |global,command,options,args|
        puts "Executed #{command.name}" if global[:v]
      end

      on_error do |exception|
        true
      end

      @kernel.exit run(@argv)
    end
  end
end
