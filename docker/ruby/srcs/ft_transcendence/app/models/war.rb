class War < ApplicationRecord
  belongs_to :guild1
  belongs_to :guild2
  belongs_to :winner
end
