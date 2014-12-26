class CategoryController < ApplicationController
	def index
		sql = 'SELECT * FROM categories ORDER BY description;'
		@categories = Category.find_by_sql(sql) 
	end
end
