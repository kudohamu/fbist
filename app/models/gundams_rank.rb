class GundamsRank < ActiveRecord::Base

  belongs_to :rank
  belongs_to :gundam

  validates_presence_of :rank_id
  validates_associated :rank

  validates_presence_of :gundam_id
end
