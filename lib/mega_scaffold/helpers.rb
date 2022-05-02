module MegaScaffold
  module Helpers

    def mega_scaffold_value(record, field)
      if field[:value].present?
        if field[:type] == :virtual
          field[:value].call record
        else
          field[:value].call record.send(field[:name])
        end
      else
        record.send(field[:name])
      end
    end

  end
end