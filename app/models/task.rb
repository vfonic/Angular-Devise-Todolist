class Task < ActiveRecord::Base
  attr_accessible :priority, :title, :user_id

  # TODO show error message when field empty
  validates_presence_of :title

  scope :prioritized, order("completed, completed_at, priority")

  belongs_to :user
end
