class @Detail
  constructor: (data_url, @template, @container, @callback) ->
    @data
    @template
    @container

    start = new Date().getTime()

    YAML.load data_url, (results) =>
      end = new Date().getTime()
      time = end - start

      @data = results
      # Fire it up
      @init()
      @callback()
  init: =>
    # Setup collection template and prepend to relative container
    html = @template.tmpl(@data)
    html.appendTo(@container)


$ ->
  $('.open-detail').on 'click', (e) =>
   click = $(e.target)
   loadDetail(click)

loadDetail = (click) ->
  # Reset Soundmanager for snoop song
  soundManager.reset()
  $('.loader').show()
  detail_path = click.data('detail-id')

  detailCollection = new Detail('/on/demandware.static/Sites-adidas-US-Site/Sites-adidas-US-Library/en_US/clp/football/football-'+detail_path+'.yml', $('#detail-template'), $('.detail-container'), =>