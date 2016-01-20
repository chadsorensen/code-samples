do ($ = jQuery) ->
  window.RhAddToCart =
    init: =>
      $sale = $('.buy-button-area')
      $addToCartButton = $('.add-to-cart')
      ARTICLE_ID = $addToCartButton.attr 'data-sku'
      product = new AdiArticle ARTICLE_ID
      $buy_btn = RhAddToCart.addSizeSelect($sale, product)
      
      RhAddToCart.buyArea($buy_btn)
      $sale.removeClass 'has-item'
      $addToCartButton.on 'click', ->
        RhAddToCart.buyBtnBind()

    buyBtnBind: ($addToCartButton) =>
      $wrapper = $(".buy-button-area")
      $addToCartButton = $('.add-to-cart')
      $addToCartText = $addToCartButton.find('.add-text')
      $addToCartTotal = $addToCartButton.find('.total')
      
      if $wrapper.hasClass 'has-item'
        sku = $addToCartButton.attr 'data-sku'
        quantity = $addToCartButton.attr 'data-quantity'
        $addToCartText.text 'Adding to bag...'
        $addToCartTotal.text ''
        $.ajax
          type: 'POST'
          url: '/us/api/cart/add'
          data:
            skuid: sku
            quantity: quantity
          success: (response) ->
            RhAddToCart.addedToBag($addToCartButton)
          error: (response) ->
            try
              data = $.parseJSON(response.responseText)
            catch e
              data =
                messages: ["Sorry, there was an error adding that item to your cart. Please try again."]
      else
        $('.option').addClass 'error'

    addedToBag: ($addToCartButton) =>
      $wrapper = $(".buy-button-area")
      $wrapper.removeClass 'has-item'
      $wrapper.attr 'product-id', ''
      $addToCartText = $addToCartButton.find('.add-text')
      $addToCartText.text('add to bag')
      RhAddToCart.updateTotal(0)
      $sizeLabel = $('.size-option .label')
      $sizeLabel.text('size')
      $quantityLabel = $('.quantity-option .label')
      $quantityTrigger = $('.quantity-option .option-trigger')
      $quantityTrigger.addClass 'disabled'
      $quantityLabel.text('qty:')

      addedText = $("<p>",
        class: "item-success"
        text: "Item successfully added!"
      ).appendTo($wrapper)
      setTimeout (->
        addedText.fadeOut(->
          addedText.remove()
        )
      ), 5000

    addSizeSelect: ($sale, product) =>
      $wrapper = $('.buy-button-area')
      $options = $wrapper.find('#size-options')
      $options.html ''
      $sizeLabel = $('.size-option .label')
      $sizeLabel.text('size')
      $price = $('.price')
      $quantityTrigger = $('.quantity-option .option-trigger')
      $quantityTrigger.addClass 'disabled'
      $quantityLabel = $('.quantity-option .label')
      $quantityLabel.text('qty:')
      RhAddToCart.updateTotal('0')
      $price.html('$')

      product.price((price) ->
        $price.html('$'+price.current)
      )

      product.skus (data) ->
        for item in data
          $button = $('<li>').text(item.size)
          if item? and item['inventory_level']? > 0
            $button.attr('data-sku', item.sku).addClass 'in-stock'
            $button.attr('data-inventory', item.inventory_level)
          else
            $button.addClass 'out-stock'
          $options.append $button

          $button.on 'click', (e) ->
            sku = $(@).data 'sku'
            inventory = $(@).data 'inventory'
            $options.find('li').removeClass 'added'
            $(@).addClass 'added'
            $options.removeClass 'open'

            $addToCartButton = $('.add-to-cart')
            $addToCartButton.attr 'data-sku', sku

            RhAddToCart.addQuantitySelect(inventory)

    addQuantitySelect: (inventory) =>
      $options = $('#quantity-options')
      $label = $('.quantity-option .label')
      $options.html ''
      i = 1
      while i <= inventory
        $option = $('<li>').text(i).attr('data-quantity', i)

        $options.append $option
        i++

        $option.on 'click', (e) ->
          quantity = $(@).data 'quantity'
          $options.find('li').removeClass 'added'
          $(@).addClass 'added'
          $options.removeClass 'open'
          RhAddToCart.updateTotal(quantity)

      $first = $('#quantity-options li').first()
      $first.addClass('added')
      $label.text('qty:'+$first.text())
      RhAddToCart.updateTotal($first.text())

    updateTotal: (quantity) =>
      total = $('.total')
      total.text("(#{quantity})")
      $addToCartButton = $('.add-to-cart')
      $addToCartButton.attr 'data-quantity', quantity

    buyArea: ($click) =>
      $wrapper = $('.buy-button-area')
      $buyButton = $wrapper.find(".add-to-cart")
      $arrow = $wrapper.find(".arrow")
      $optionWrapper = $wrapper.find(".option")
      $total = $wrapper.find(".total")
      $optionWrapperLabel = $optionWrapper.find(".label")
      $chosenSize = $wrapper.find(".size-chosen")
      optionMouseTimeout = undefined

      unless $wrapper.hasClass("has-item")
        $wrapper.addClass "add-clicked"

      $chosenSize.click ->
        $wrapper.addClass "add-clicked"

      $optionWrapper.on("mouseenter", ->
        clearTimeout optionMouseTimeout
        return
      ).on "mouseleave", ->
        optionMouseTimeout = setTimeout(->
          $wrapper.removeClass "open"
          $optionWrapper.removeClass "open"
        , 300)

      $optionWrapperLabel.click (e) ->
        $click = $(e.currentTarget)
        $trigger = $click.closest('.option-trigger')
        if $trigger.hasClass 'disabled'
          $('.size-option').addClass 'error'
        else
          $wrapper.addClass "open"
          $option = $click.closest('.option')
          $option.addClass 'open'

      $arrow.click (e) ->
        if $optionWrapper.hasClass 'open'
          $wrapper.removeClass "open"
          $optionWrapper.removeClass "open"
        else
          $click = $(e.currentTarget)
          $trigger = $click.closest('.option-trigger')
          unless $trigger.hasClass 'disabled'
            $wrapper.addClass "open"
            $option = $click.closest('.option')
            $option.addClass 'open'

      $optionWrapper.find(".options").on "click", "li", (e) ->
        $current = $(e.currentTarget)
        $('.option').removeClass 'error'
        $('.option-trigger').removeClass 'disabled'
        value = $current.text()
        $label = $current.closest('.option').find('.label')
        quantity = $current.data 'quantity'
        if typeof quantity isnt typeof `undefined` and quantity isnt false
          $label.text('qty:'+value)
        else
          $label.text(value)
        $wrapper.removeClass("add-clicked open").addClass "has-item"
        $optionWrapper.removeClass 'open'