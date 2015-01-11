class Company < ActiveRecord::Base
	has_many :locations
	has_many :services
	has_many :company_contacts
	has_many :people,  through: :company_contacts
	belongs_to :category

	def unique
		# Return true if this new company is unique by: name and category

		sql = 'SELECT id FROM companies WHERE name = ? AND category_id = ?;'
		record_found = Company.find_by_sql [sql, self.name, self.category_id]

		if record_found.blank?
			true # no conflict with any existing record
		else
			(record_found[0].id == self.id) # no conflict if we found the record we started with
		end

	end

end
