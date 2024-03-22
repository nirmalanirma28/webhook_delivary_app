class Comment < ApplicationRecord
    validates :contents, presence: true
    validates :endpoint, presence: true
    validates :post_id, presence: true
end
