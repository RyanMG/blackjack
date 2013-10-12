class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->
    @width = 268

  hit: ->
    @width += 142
    if not @isDealer
      $ =>
        $('.playerHand').css({ 'width' : @width})
    else
      $ =>
        console.log 'dealer hits'
        $('.dealerHand').css({ 'width' : @width})

    @add(@deck.pop())

    if @getScore() > 21
      @trigger 'bust'
    else if @getScore() is 21
      @trigger 'natural'

  getScore: ->
    if @scores()[1]
      if @scores()[1] > 21
        return @scores()[0]
      else return @scores()[1]
    return @scores()[0]

  revealHand: -> @at(0).flip()

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]
