class Muteship < ActiveRecord::Base
	belongs_to :user, class_name: :User, required: true
	belongs_to :muted, class_name: :User, required: true
end
