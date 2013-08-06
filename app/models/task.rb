class Task < ActiveRecord::Base
  attr_accessible :priority, :title

  # TODO show error message when field empty
  validates_presence_of :title
end
