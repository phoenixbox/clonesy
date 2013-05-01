module Uber::StatisticsHelper

  def orders_value_chart_data
    OrderItem.select("date(created_at) as date, sum(quantity * unit_price) as total")
                       .group("date(created_at)")
  end

  def top_five_products
    OrderItem.select("product_id as label, sum(quantity) as value").group("product_id").order("value DESC").limit(5)
  end

  def aspu
    OrderItem.select("date(created_at) as y, sum(quantity * unit_price) as a")
                       .group("date(created_at)")
  end

end