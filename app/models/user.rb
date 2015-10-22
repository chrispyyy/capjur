class User < ActiveRecord::Base

  has_many :captions
  has_many :votes


end
