class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :tool_call

  acts_as_message # Basic RubyLLM integration
  broadcasts_to ->(message) { [ message.chat, "messages" ] }

  # Optional: Add this line to enable attachment support
  has_many_attached :attachments

  validates :role, presence: true
  validates :chat, presence: true

  def broadcast_append_chunk(chunk_content)
    broadcast_append_to [ chat, "messages" ], # Target the stream
      target: dom_id(self, "content"), # Target the content div inside the message frame
      html: chunk_content # Append the raw chunk
  end
end
