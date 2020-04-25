class Movie < ActiveRecord::Base
    def self.all_ratings
       @all_ratings = ["G", "PG", "PG-13", "R"] 
       return @all_ratings
    end
end
