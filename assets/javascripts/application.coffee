$('.js-publisher').on 'click', (e) ->
	$this = $(this)
	publisher = $this.data().publisher

	$('.js-name').html(publisher.name)

