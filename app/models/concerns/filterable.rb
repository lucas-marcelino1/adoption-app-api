module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |filter, value|
        results = results.public_send("by_#{filter}", value) if value.present?
      end
      results
    end
  end

end
