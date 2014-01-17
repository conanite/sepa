# -*- coding: utf-8 -*-
require 'bigdecimal'
module Sepa
  class Base
    include Aduki::Initializer

    @@attribute_defs = Hash.new { |h,k| h[k] = [] }

    def build_xml_attributes names
      result = { }
      (names || { }).each { |k,v|
        result[k] = self.send v
      }
      result
    end

    def empty?
      false
    end

    def normalize str
      return str if str.is_a? Fixnum
      return ("%.2f" % str) if str.is_a? Float
      return ("%.2f" % str) if str.is_a? BigDecimal
      replacements = {
          'à' => 'a', 'é' => 'e', 'è' => 'e',
          'û' => 'u', 'î' => 'i', 'ô' => 'o', 'ü' => 'u', 'ï' => 'i', 'ö' => 'o',
          'ÿ' => 'y', 'ç' => 'c', 'Ç' => 'C', 'É' => 'E', 'È' => 'E', 'á' => 'a',
          'À' => 'A', 'Á' => 'A', 'Ü' => 'U', 'Ï' => 'I', 'Ö' => 'O', 'ß' => 'ss'
      }
      str = replacements.to_a.
        inject(str) { |s, kv| s.gsub(kv[0], kv[1]) }.
        gsub(/[^a-zA-Z0-9_@ \.,()'+\/\?-]/, '')
    end

    def to_xml builder
      self.class.attribute_defs.each do |name, meta|
        item = self.send(name)
        options = meta[:options] || { }
        attributes = build_xml_attributes options[:attributes]
        next if item == nil || (item.is_a?(Sepa::Base) && item.empty?)
        if meta[:type] == :string
          builder.__send__(meta[:tag], normalize(item), attributes)
        elsif meta[:type] == :[]
          if meta[:member_type] == nil
            item.each { |obj| builder.__send__(meta[:tag], normalize(obj), attributes) }
          else
            item.each do |obj|
              builder.__send__(meta[:tag], attributes) { obj.to_xml builder }
            end
          end
        elsif meta[:type] == Time
          v = item.is_a?(String) ? item : item.strftime("%Y-%m-%dT%H:%M:%SZ")
          builder.__send__(meta[:tag], v, attributes)
        elsif meta[:type] == Date
          v = item.is_a?(String) ? item : item.strftime("%Y-%m-%d")
          builder.__send__(meta[:tag], v, attributes)
        elsif meta[:type].is_a? Class
          builder.__send__(meta[:tag], attributes) { item.to_xml builder }
        end
      end
    end

    def self.attribute_defs
      @@attribute_defs[self]
    end

    def self.attribute_defs= arg
      @@attribute_defs[self]= arg
    end

    def self.definition txt
    end

    def self.code_or_proprietary
      attribute :code       , "Cd"
      attribute :proprietary, "Prtry"
    end

    def self.attribute name, tag, type=:string, member_type=nil, options={ }
      if type == :[]
        array_attribute name, tag, member_type, options
      elsif type.is_a?(Class) && type != Time && type != Date
        typed_attribute name, tag, type, options
      else
        attr_accessor name
        attribute_defs << [name, { :tag => tag, :type => type, :options => options }]
      end
    end

    def self.typed_attribute name, tag, type, options
      attribute_defs << [name, { :tag => tag, :type => type, :options => options }]
      attr_accessor name
      aduki name => type
    end

    def self.array_attribute name, tag, member_type=nil, options={ }
      attribute_defs << [name, { :tag => tag, :type => :[], :member_type => member_type, :options => options }]
      attr_accessor name
      aduki(name => member_type) if member_type
    end
  end
end
