if RUBY_PLATFORM == 'java'
  class Enumerator
    class Lazy
      def initialize(coll)

        @lazy = Yid.new do |yielder|
          if block_given?
            coll.each do |x|
              yield yielder, x
            end
          else
            coll.each do |x|
              yielder.yield x
            end
          end
        end
      end

      def each
        loop { yield @lazy.next }
      rescue StopIteration
      end

      def select
        Lazy.new(self) do |yielder, *vals|
          result = yield(*vals)
          yielder.yield(*vals) if result
        end
      end

      def map
        Lazy.new(self) do |yielder, *vals|
          yielder.yield yield(*vals)
        end
      end

      def take(n)
        i = 0
        Lazy.new(self) do |yielder, *vals|
          if i < n
            i += 1
            yielder.yield(*vals)
          else
            raise StopIteration
          end
        end
      end

      def take_while
        stop_iter = false
        Lazy.new(self) do |yielder, *vals|
          raise StopIteration if stop_iter
          result = yield(*vals)
          if result
            yielder.yield(*vals)
          else
            stop_iter = true
          end
        end
      end

      def drop(n)
        i = 0
        Lazy.new(self) do |yielder, *vals|
          if i < n
            i += 1
          else
            yielder.yield(*vals)
          end
        end
      end

      def drop_while
        to_drop = true
        Lazy.new(self) do |yielder, *vals|
          if to_drop
            to_drop = false if yield(*vals)
          end

          if !to_drop
            yielder.yield(*vals)
          end
        end
      end

      def next
        @lazy.next
      end

      def force
        ret = []
        while val = @lazy.next
          ret << val
        end
      rescue StopIteration
        ret
      end

      private
      # kudos http://stackoverflow.com/a/19660333/482757
      class Yid
        def initialize(&block)
          # creates a new Fiber to be used as an Yielder
          @yielder  = Fiber.new do
            yield Fiber
            raise StopIteration # raise an error if there is no more calls
          end
        end

        def next
          # return the value and wait until the next call
          @yielder.resume
        end
      end
    end
  end

  module Laziable
    def lazy
      Enumerator::Lazy.new(self)
    end
  end

  class Range
    include Laziable
  end
end
