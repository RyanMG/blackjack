#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    # not firing to view, as view is not available yet
    if @get('playerHand').getScore() is 21
      @set 'message', 'player blackjack'
      @set 'winner', 'player'
      @endGame()

    @get('playerHand').on 'bust', =>
      @set 'message', 'player busts'
      @get('dealerHand').revealHand()
      @set 'winner', 'dealer'

    @get('dealerHand').on 'bust', =>
      @set 'message', 'dealer busts'
      @set 'winner', 'player'

    @get('playerHand').on 'natural', =>
      console.log 'app: natural'
      @endGame()

  endGame: ->
    @get('dealerHand').revealHand()
    playerScore = @get('playerHand').getScore()

    while @get('dealerHand').getScore() < 17
      @get('dealerHand').hit()

    if @get('dealerHand').getScore() < 21
      if playerScore > @get('dealerHand').getScore()
        @set 'winner', 'player'
      else if playerScore < @get('dealerHand').getScore()
        @set 'winner', 'dealer'
      else
        @set 'winner', 'tie'

  reset: ->
    @initialize()
    @unset 'winner', {silent:true}
    @unset 'message', {silent:true}
    console.log 'unset', @get 'winner'
    @trigger 'redraw'