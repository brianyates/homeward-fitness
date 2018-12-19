class CorrectedDateType < ActiveRecord::Type::Date
	def cast(value)
		if value.present?
			if value.kind_of?(String) && value.include?("/")
				new_date = Date.strptime(value, "%m/%d/%Y").strftime("%Y-%m-%d")
				super(new_date)
			else
				super
			end
		else
			super
		end
	end
end
ActiveRecord::Type.register(:corrected_date, CorrectedDateType, override: true)