module MegaScaffold
  class TypeDetector
    def TypeDetector.find_type(field)
      case field.type
      when :datetime
        :datetime_field
      when :date
        :date_field
      when :text
        :text_area
      when :boolean
        :check_box
      when :integer
        :number_field
      else
        case field.name
        when /password/
          :password_field
        when /phone/
          :phone_field
        when /email/
          :email_field
        when /color/
          :color_field
        when /url/
          :url_field
        else
          :text_field
        end
      end
    end
  end
end
