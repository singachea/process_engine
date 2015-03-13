module ProcessEngine
  class ApplicationController < ActionController::Base
    layout 'process_engine/layouts/application'

    def update_active_record_complex_type(entity)
      begin
        return yield
      rescue JSON::ParserError
        check_error_parsing_attribute_type entity, "JSON is invalid"
      rescue TypeError
        check_error_parsing_attribute_type entity, "Array is invalid. e.g. {element1,element2} without space"
      end
      false
    end

    private

    def check_error_parsing_attribute_type(entity, message)
      entity.attribute_names.each do |an|
        begin
          entity.send(an)
        rescue
          entity.errors.add(an, message)
        end
      end
    end
  end
end
