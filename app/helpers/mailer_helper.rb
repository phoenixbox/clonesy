module MailerHelper
  def role_link(role, store)
    if role == 'admin'
      store_admin_manage_url(store, host: HOST_DOMAIN)
    elsif role == 'stocker'
      store_stock_products_url(store, host: HOST_DOMAIN)
    end
  end
end
