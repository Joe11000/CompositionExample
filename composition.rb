require 'active_support/core_ext/object/blank'

class House
  attr_reader :items, :format

  def initialize(args)
    args = default_params.merge args

    @items = args.fetch(:order).order(args[:items])
    @format = args.fetch(:format).format(args[:items])
  end

  private
    def default_params
      {
        items: %w(one two three four five six),
        order: DoNotOrder.new,
        format: NoFormatter.new
      }
    end
end


module Interfaces
  module Orderable
    def order
      raise NotImplementedError, '#order method needs to be overwritten'
    end
  end
end

class Alphabetize
  include Interfaces::Orderable

  def order items
    items.sort
  end
end

class Randomizer
  include Interfaces::Orderable

  def order items
    items.shuffle
  end
end

class DoNotOrder
  include Interfaces::Orderable

  def order items
    items
  end
end



module Interfaces
  module Formatable
    def format items
      raise NotImplementedError, "#format(items) must be overwritten"
    end
  end
end

class NoFormatter
  include Interfaces::Formatable

  def format items
    p items
  end
end

class StringFormatter
  include Interfaces::Formatable

  def format items
    items.join(', ')
  end
end



module Factory
  module Order
    def self.alphabetize items=({})
      h = items.blank? ? {} : ({ items: items })
      House.new({ order: Alphabetize.new }.merge(h))
    end

    def self.random items=({})
      h = items.blank? ? {} : ({ items: items })
      House.new({ order: Randomizer.new }.merge(h))
    end

    def self.do_not_order items=({})
      h = items.blank? ? {} : ({ items: items })
      House.new({ order: DoNotOrder.new }.merge(h))
    end
  end

  module Format
    def self.no_format items=({})
      h = items.blank? ? {} : ({ items: items })
      House.new({ format: NoFormatter.new }.merge(h))
    end

    def self.string_format items=({})
      h = items.blank? ? {} : ({ items: items })
      House.new({ format: StringFormatter.new }.merge(h))
    end
  end

  module FormatAndOrder
    def self.random_with_string_format items=({})
      h = items.blank? ? {} : ({ items: items })
      House.new({ order: Alphabetize.new, format: StringFormatter.new }.merge(h))
    end
  end
end


require 'benchmark'
require 'pry'
Benchmark.bmbm(45) do |bmbm|
  bmbm.report('Factory::Order.alphabetize')    { Factory::Order.alphabetize }
  bmbm.report('Factory::Order.random')         { Factory::Order.random }
  bmbm.report('Factory::Order.do_not_order')   { Factory::Order.do_not_order }

  bmbm.report('Factory::Format.no_format')     { Factory::Format.no_format }
  bmbm.report('Factory::Format.string_format') { Factory::Format.string_format }

  bmbm.report('Factory::FormatAndOrder.random_with_string_format') { Factory::FormatAndOrder.random_with_string_format }
end
