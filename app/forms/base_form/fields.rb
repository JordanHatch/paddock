module BaseForm::Fields
  extend ActiveSupport::Concern

  module ClassMethods
    def deserialize_date_fields_from_form(form, attributes)
      date_fields = form.schema
        .select {|k| k.type.primitive == Date }
        .map(&:name)

      date_fields.each do |key|
        if attributes.key?("#{key}(1i)")
          year = attributes["#{key}(1i)"].to_i
          month = attributes["#{key}(2i)"].to_i
          day = attributes["#{key}(3i)"].to_i

          attributes[key] = begin
                              Date.new(year, month, day)
                            rescue
                              nil
                            end

          attributes.delete("#{key}(1i)")
          attributes.delete("#{key}(2i)")
          attributes.delete("#{key}(3i)")
        end
      end
    end
  end

end
