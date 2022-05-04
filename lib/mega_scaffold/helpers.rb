module MegaScaffold
  module Helpers

    def mega_scaffold_value(record, field, type = :show)
      if field[:value].is_a?(Proc)
        field[:value].call record, self
      elsif field[:value].is_a?(Hash)
        field[:value][type].call record, self
      else
        record.send(field[:name])
      end
    end

    def mega_scaffold_field_name(field)
      (field[:label].presence || field[:name]).to_s.titleize
    end

    def mega_scaffold_parent_url
      [mega_scaffold.scope&.to_sym, @parent].reject(&:blank?)
    end

  end
end