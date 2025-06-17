class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :tool_call

  acts_as_message # Basic RubyLLM integration

  # Optional: Add this line to enable attachment support
  has_many_attached :attachments

  validates :role, presence: true
  validates :chat, presence: true
end
