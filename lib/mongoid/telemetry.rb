module Mongoid
  class Telemetry
    def self.call(key, payload = {}, &block)
      return block.call unless adapter

      adapter.instrument(key_for(key, payload), payload.merge(method_name: key)) { block.call }
    end

    def self.key_for(key, payload)
      ['mongoid', name_from_class(payload[:klass]), key].compact.map(&:downcase).join('.')
    end

    def self.name_from_class(klass)
      return unless klass
      klass.name.gsub(/[a-z0-1][A-Z]/) { |m| m.insert(1, '_') }
    end

    def self.adapter
      @adapter
    end

    def self.adapter=(adp)
      @adapter = adp
    end
  end
end
