class  OrderConfirmEmailJob
  @queue = :email

  def self.perform(user, order_id, order_total)
    Mailer.order_confirmation(user, order_id, order_total).deliver
  end

end
