module MegaScaffold
  module Helpers

    def mega_scaffold_default_css
      tag.style %Q{
        .mega_scaffold_container {
          padding-top: 20px;
        }
        
        .mega_scaffold_container .mega_scaffold_container_header {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        
        .mega_scaffold_container .field_with_errors input,
        .mega_scaffold_container .field_with_errors select,
        .mega_scaffold_container .field_with_errors textarea {
          border: 1px solid red;
        }
        
        .mega_scaffold_container abbr {
          color: red;
          text-decoration: none;
        }
        
        .mega_scaffold_container table {
          width: 100%;
        }

        .mega_scaffold_container form .mega_scaffold_field_multiple label {
          padding-left: 5px;
          margin-right: 10px;
        }

        .mega_scaffold_container .pagination > * {
          margin-right: 10px;
        }

        .mega_scaffold_container .mega_scaffold_errors {
          font-size: 14px;
          color: red;
        }

        .mega_scaffold_container .mega_scaffold_errors h4 {
          font-size: 16px;
        }
      }.html_safe
    end

    def mega_scaffold_value(record, field, type = :show)
      if field[:value].is_a?(Proc)
        field[:value].call record, self
      elsif field[:value].is_a?(Hash)
        field[:value][type].call record, self
      else
        record.send(field[:name])
      end
    end

    def mega_scaffold_parent_url
      [mega_scaffold.scope&.to_sym, @parent].reject(&:blank?)
    end

    def mega_scaffold_form_url(record)
      [mega_scaffold.scope&.to_sym, @parent, record].reject(&:blank?)
    end

  end
end