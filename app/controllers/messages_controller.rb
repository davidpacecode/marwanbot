class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]
  before_action :set_chat

  # GET /messages or /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    message_content = params[:content]

    # Queue the background job to handle the streaming response
    ChatStreamJob.perform_later(@chat.id, message_content)

    # Immediately return success to the user
    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to @chat }
    end

    # original generated content
    # @message = Message.new(message_params)

    # respond_to do |format|
    #   if @message.save
    #     format.html { redirect_to @message, notice: "Message was successfully created." }
    #     format.json { render :show, status: :created, location: @message }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @message.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to messages_path, status: :see_other, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.fetch(:message, {})
    end

   def set_chat
     @chat = Chat.find(params[:chat_id])
   end
end
