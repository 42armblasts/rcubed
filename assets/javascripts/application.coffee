$('.js-publisher').on 'click', (e) ->
  $this = $(this)
  publisher = $this.data().publisher

  $('.js-name').html(publisher.name)

  url = "/daily-revenue/#{publisher.id}.json"
  $.get url, (data, status, xhr) ->
    $('.js-days-revenue').html(formatCentsToDollar(data.total_revenue))
    $('.js-order-count').html(data.order_count)
    $('.js-net-rev-margin').html("#{data.net_rev_margin}%")

formatCentsToDollar = (value) ->
  dollars = value / 100
  if dollars == Math.floor(dollars)
    "$" + dollars.toFixed(0)
  else
    "$" + dollars.toFixed(2)
