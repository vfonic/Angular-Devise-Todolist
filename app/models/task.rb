class Task < ActiveRecord::Base
  attr_accessible :priority, :title, :user_id, :completed_at, :completed

  # TODO show error message when field empty
  validates_presence_of :title

  scope :prioritized, order("priority")

  belongs_to :user

  def completed
    !completed_at.blank?
  end

  def completed=(completed)
    if completed
      self.completed_at = Time.zone.now
    else
      self.completed_at = nil
    end
  end

  def as_json(options = {})
    {
      id: id,
      title: title,
      priority: priority,
      importance: importance,
      completed: completed,
      completed_at: completed_at,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id
    }
  end
end
