UpsellItems =
  init: ->
    @$upsell_container = $j('.block-upsell')
    @$upsell_overflow = $j('.block-upsell .options-wrapper')
    @$open_upsell_button = $j('.upsell-button')
    @$open_upsell_button_label = $j('.upsell-button .count')
    @$close_upsell_button = $j('.box-upsell .active-label')
    @$close_upsell_button_label = $j('.box-upsell .active-label .label')
    @$removeButton = $j('.active-label .remove-button')
    @$optionsContainer = $j('.options-container')
    @$items = $j('.mini-products-list .upsell-item .product')
    @$itemCheckBoxes = $j('.upsell-checkbox')

    @$open_upsell_button.on 'click', @openUpsells
    
    @$close_upsell_button.on 'click', (e) =>
      $click = $j(e.target)
      if $click.hasClass 'remove-button'
        @resetUpsells()
      else
        @closeUpsells()

    @$items.on 'click', (e) =>
      e.preventDefault()
      @checkItems(e)

  openUpsells: =>
    maxHeight = @calculateMaxHeight()
    @$upsell_overflow.css('max-height', maxHeight)
    @$upsell_container.addClass 'open'

  closeUpsells: =>
    @$upsell_container.removeClass 'open'
    
  calculateMaxHeight: =>
    headerHeight = $j('.options-label').height()
    footerHeight = $j('.active-label').height()
    bodyHeight = $j('.product-shop').height()
    return bodyHeight - (headerHeight + footerHeight)

  resetUpsells: =>
    $checkboxes = $j('.upsell-checkbox')
    @$items.removeClass 'selected'
    @$close_upsell_button_label.text(0)
    $checkboxes.attr('checked', false)
    @addUpsellsToProduct()


  checkItems: (e) =>
    $current = $j(e.currentTarget)
    $currentCheckBox = $current.find('.upsell-checkbox')
    if $current.hasClass 'selected'
      @removeItem($current, $currentCheckBox)
    else
      @addItem($current, $currentCheckBox)

  removeItem: ($current, $currentCheckBox) =>
    $current.removeClass 'selected'
    $currentCheckBox.prop('checked', false)
    @addUpsellsToProduct()

  addItem: ($current, $currentCheckBox) =>
    $currentCheckBox.prop('checked', true)
    @addUpsellsToProduct()
    $current.addClass 'selected'

  addUpsellsToProduct: =>
    $checkboxes = $j('.upsell-checkbox')
    values = []
    $checkboxes.each ->
      if $j(@).is(':checked')
        values.push $j(@).val()
    $j('#related-products-field').val values.join(',')
    @$close_upsell_button_label.text(values.length)
    @$open_upsell_button_label.text(values.length)
    if values.length > 0
      @$open_upsell_button.addClass 'active'
      @$removeButton.addClass 'active'
    else
      @$open_upsell_button.removeClass 'active'
      @$removeButton.removeClass 'active'

$j ->
  UpsellItems.init