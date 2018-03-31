#!/usr/bin/env ruby

require_relative 'composition'
require 'benchmark'

Benchmark.bm(50) do |bmbm|
  bmbm.report('Factory::Order.alphabetize')    { Factory::Order.alphabetize }
  bmbm.report('Factory::Order.random')         { Factory::Order.random }
  bmbm.report('Factory::Order.do_not_order')   { Factory::Order.do_not_order }

  bmbm.report('Factory::Format.no_format')     { Factory::Format.no_format }
  bmbm.report('Factory::Format.string_format') { Factory::Format.string_format }

  bmbm.report('Factory::FormatAndOrder.random_with_string_format') { Factory::FormatAndOrder.random_with_string_format }
end
