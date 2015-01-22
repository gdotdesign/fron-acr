require 'fron/active_record'

module Fron
  module ActiveRecord
    class Middleware < Opal::Environment
      def self.call(env)
        [200, {'Content-Type' => 'text/javascript'}, [Opal.process('fron/active_record.js')]]
      end
    end
  end
end
