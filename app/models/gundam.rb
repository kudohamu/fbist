class Gundam < ActiveRecord::Base
  belongs_to :cost

  has_many :records

  mount_uploader :icon, GundamIconUploader

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: true
  validates_length_of :name, maximum: 45

  validates_presence_of :no
  validates_uniqueness_of :no, case_sensitive: true
  validates_numericality_of :no, greater_than: 0, less_than: 1000000

  validates_presence_of :wiki
  validates_uniqueness_of :wiki, case_sensitive: true
  validates_length_of :wiki, maximum: 500
  validates_format_of :wiki, with: /\A[a-zA-z0-9\-_\.!'\(\)\/\?@&=\+\$%#]*\z/

  validates_associated :cost
end
