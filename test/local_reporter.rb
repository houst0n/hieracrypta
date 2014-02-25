# Blatantly stolen from somewhere!

require 'ansi/code'
require "minitest/reporters"

module Minitest
  module Reporters
    class LocalReporter < BaseReporter
      include ANSI::Code
      include RelativePosition

      def start
        super
      end

      def report
        super
        puts('Finished in %.5fs' % total_time)
        print('%d tests, %d assertions, ' % [count, assertions])
        color = failures.zero? && errors.zero? ? :green : :red
        print(send(color) { '%d failures, %d errors, ' } % [failures, errors])
        print(yellow { '%d skips' } % skips)
        puts
      end

      def record(test)
        super
        print_colored_status(test)
        print(" (%.2fs)" % test.time)
        print pad_test(test.name.gsub(/^test_\d{4}_/,''))
        puts
        return if test.skipped?
        if test.failure
          print_info(test.failure); puts
        end
      end

      def before_suite(suite)
        puts suite
      end
    end
  end
end
