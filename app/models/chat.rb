class Chat < ApplicationRecord
  acts_as_chat # Assumes Message and ToolCall model names

  belongs_to :user, optional: true # Example
  validates :model_id, presence: true # Example
end
