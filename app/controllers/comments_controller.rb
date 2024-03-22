class CommentsController < ApplicationController
    def create
        @comment = Comment.new(comment_params)
        if @comment.save
            notify_third_party_api(@comment)
            render json: @comment, status: :created            
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    def update
        @comment = Comment.find(params[:id])
        if @comment.update(comment_params)
            notify_third_party_api(@comment)
            render json: @comment, status: :ok
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    private

    def comment_params
        params.require(:comment).permit(:contents, :post_id, :endpoint)
    end

    def notify_third_party_api(comment)        
        response = HTTParty.post(comment.endpoint, body: comment.contents.to_json, headers: { 'Content-Type' => 'application/json', secret: "test_key" })
        Rails.logger.error("Failed to send webhook notification to #{comment.endpoint}: #{response.code}") unless response.success?
    end
end
