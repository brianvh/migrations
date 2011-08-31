module LDAPSync

  class Entry
    attr_reader :attributes

    def initialize(hash, attrs=nil)
      @attributes = {}
      parse_dn(hash)
      parse_attributes(hash, attrs || [])
    end

    def inspect
      attributes.inspect
    end

    private

    def parse_dn(hash)
      return no_dn_error if hash['dn'].nil?
      dn = hash['dn'].first
      cn = dn.split(',')[0].gsub(/^cn=/, '')
      attributes[:cn] = cn
    end

    def parse_attributes(hash, attrs)
      attrs.each do |attr|
        attributes[attr.to_sym] = hash[attr].nil? ? nil : hash[attr].first
      end
    end

    def method_missing(method_id)
      attrib = method_id.to_sym
      return attributes[attrib] if attributes.has_key?(attrib)
      super
    end

    def no_dn_error
      raise 'Entry hash missing the dn key.'
    end
  end

end
