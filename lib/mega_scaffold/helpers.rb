module MegaScaffold
  module Helpers

    def mega_scaffold_value(record, field)
      if field[:value].present?
        field[:value].call record
      else
        record.send(field[:name])
      end
    end

  end
end