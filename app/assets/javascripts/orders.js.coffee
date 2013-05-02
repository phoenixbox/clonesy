jQuery ->
  Morris.Line
    element: 'orders_chart'
    data: $('#orders_chart').data('orders')
    xkey: 'date'
    ykeys: ['total']
    ymax: 'auto'
    xLabels: 'month'
    yLabels: '$'
    preUnits: '$'
    labels: ['Total']
    hideHover: false

jQuery ->
  Morris.Donut
    element: 'donut_chart'
    data: $('#donut_chart').data('products')

jQuery ->
  Morris.Bar
    element: 'bar_chart'
    data: $('#bar_chart').data('spend')
    xkey: 'y'
    ykeys: ['a']
    labels: ["Average Order Spend"]
    preUnits: '$'