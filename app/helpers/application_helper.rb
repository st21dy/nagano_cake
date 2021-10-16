module ApplicationHelper

  
  def full_title(title = "")
    base_title = "NaganoCAKE"
	    if admin_signed_in?
			  base_title + "|" + "(管理者) #{title}"
		  else
			  base_title + "|" + "#{title}"
		  end
  end

	def full_name(customer)
		customer.last_name + customer.first_name
	end

	def kana_full_name(customer)
		customer.kana_last_name+customer.kana_first_name
	end

  def full_address(key)
		  "#{key.postal_code} #{key.address}"
  end

end
