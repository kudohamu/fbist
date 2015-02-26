class Cost < ActiveRecord::Base
  has_many :gundams

  validates_presence_of :cost
  validates_uniqueness_of :cost
  validates_numericality_of :cost, greater_than: 0, less_than: 10000
end
