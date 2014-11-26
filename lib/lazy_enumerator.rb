require 'enumerator/ruby_lazy_enumerator.jar'

class Enumerator
end

module Laziable
  def lazy
    Enumerator::Lazy.new(self)
  end
end

class Array
  include Laziable
end

class Range
  include Laziable
end
