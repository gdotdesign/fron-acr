require 'active_support'

class Hash
  def compact(opts={})
    inject({}) do |new_hash, (k,v)|
      if !v.blank?
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact(opts) : v
      end
      new_hash
    end
  end
end

module Fron
  module ActiveRecord
    module Model
      extend ::ActiveSupport::Concern

      class << self
        attr_reader :tables
      end

      def self.included(other)
        @tables ||= []
        @tables << other
        other.setup
      end

      module ClassMethods
        attr_reader :model

        def setup
          rescue_from ::ActiveRecord::RecordNotFound, ::ActiveRecord::RecordInvalid

          format :json

          @model = name.split('::').last.constantize

          prefix @model.name.demodulize.underscore

          helpers do
            params(:object) do
              @api.instance_variable_get('@model').reflect_on_all_associations
                .map { |assoc| "#{assoc.name.to_s.singularize}_ids".to_sym }.each do |assoc|
                optional assoc
              end

              (@api.instance_variable_get('@model').column_names - ['id']).each do |name|
                optional name
              end
            end

            def model
              env['api.endpoint'].options[:for].instance_variable_get('@model')
            end
          end

          params { use :object }
          route :any, :where do
            model.where(declared(params, include_missing: false).compact).to_a
          end

          params { requires :id }
          route :any, :find do
            model.find params[:id]
          end

          params { use :object }
          route :any, :create do
            model.create! declared(params)
          end

          params { requires :id }
          route :any, :destroy do
            model.find(params[:id]).destroy
          end

          params do
            use :object
            requires :id
          end
          route :any, :update do
            item = model.find(params[:id])
            item.update_attributes!(declared(params, include_missing: false))
            item
          end
        end
      end
    end
  end
end
