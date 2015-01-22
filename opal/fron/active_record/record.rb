module Fron
  module ActiveRecord
    class Record < Fron::Component
      class Manager
        class << self
          def model(name, path)
            @models ||= {}
            @models[name] = path
          end

          def find(model)
            @managers ||= {}
            return @managers[model] if @managers.keys.include? model
            @managers[model] = Fron::ActiveRecord::Manager.new @models[model]
            @managers[model]
          end

          alias_method :[], :find
        end
      end

      module Manageable
        def model(value = nil)
          return @model = value if value
          # Hack???
          parent = `#{self}._super`
          @model || (parent.model if parent.respond_to?(:model))
        end

        def manager
          Manager.find(model)
        end

        def self.extended(other)
          other.extend Forwardable
          other.def_delegators :class, :manager
        end
      end

      class List < Fron::Component
        extend Manageable

        class << self
          def base(klass = nil)
            return @base unless klass
            @base = klass
          end
        end

        def all
          manager.all do |records|
            yield records.map { |data| create_item data }
          end
        end

        def create(data)
          manager.create data do |record|
            yield create_item record
          end
        end

        def initialize
          super nil
          @items = []
          update
        end

        def update
          @items.clear
          all do |items|
            @items = items
            render if respond_to? :render
          end
        end

        private

        def create_item(data)
          item = self.class.base.new
          item.initialize! data
          item.render
          item
        end
      end

      extend Manageable

      class << self
        def path(value)
          @path = value
        end

        def property(key, type)
          define_method key do
            @data[key]
          end
        end
      end

      def render
      end

      def bind(id)
        manager.find id do |data|
          initialize! data
          render
        end
      end

      def update(data)
        manager.update @data[:id].to_i, data do |data|
          @data.merge! data
          yield
        end
      end

      def destroy!
        self.class.manager.destroy @data[:id] do
          yield
        end
      end

      private

      def initialize!(data)
        @data = data
      end
    end
  end
end
