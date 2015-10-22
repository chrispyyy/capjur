class Caption < ActiveRecord::Base

  belongs_to :user
  belongs_to :image

  has_many :votes

  validates_presence_of :text

end
