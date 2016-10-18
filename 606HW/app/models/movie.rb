class Movie < ActiveRecord::Base
	def self.load
		ratings=Array.new()
		self.select("rating").uniq.each{|movie| ratings.push(movie.rating)}
		p ratings#do not know why have some encode problems without this
	end
end
