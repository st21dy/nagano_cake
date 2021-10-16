class Item < ApplicationRecord
  
  belongs_to :genre
	has_many :cart_items
	has_many :orders, through: :order_details
	has_many :order_details

	attachment :image

	validates :genre_id, :name, :price, presence: true
	validates :introduction, length: {maximum: 200}
	validates :price, numericality: { only_integer: true }
	
	## 消費税を求めるメソッド
	def with_tax_price
    (price * 1.1).floor
	end

end
