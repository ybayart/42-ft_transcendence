class Guild < ApplicationRecord
	belongs_to :owner, class_name: "User"
	has_many :guild_link_officers
	has_many :officers, :through => :guild_link_officers, :source => :user
	has_many :members, class_name: "User", foreign_key: "guild_id", inverse_of: :guild
	has_many :wars
end
