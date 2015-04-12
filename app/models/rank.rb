class Rank < ActiveRecord::Base
  has_many :gundams_ranks
  has_many :gundams, through: :gundams_ranks

  validates_presence_of :no

  validates_presence_of :rank
end
