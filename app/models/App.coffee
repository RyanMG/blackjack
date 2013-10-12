#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @resetHands()

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

    if @get('dealerHand').getScore() is 21
      if playerScore is 21
        @set 'winner', 'tie'
      else @set 'winner', 'dealer'

  resetHands: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

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

    @unset 'winner', {silent:true}
    @unset 'message', {silent:true}
    console.log 'unset', @get 'winner'
    @trigger 'redraw'

    #@checkForBlackJack()
    @get('player').bet() if @get 'player'

  createPlayer: (name) ->
    @set 'player', new Player({name: name})

  checkForBlackJack: ->
    if @get('playerHand').getScore() is 21
      @set 'message', 'player blackjack'
      @set 'winner', 'player'

  payout: (winner) ->
    if winner is 'player' and @get('message') isnt 'player blackjack'
      $ ->
        $('.payout').html('<p>You win $20!</p>')
      @get('player').wins(20)
    else if winner is 'player' and @get('message') is 'player blackjack'
      $ ->
        $('.payout').html('<p>You win $40!</p>')
      @get('player').wins(40)
    else if winner is 'tie'
      $ ->
        $('.payout').html('<p>You win your bet back!</p>')
      @get('player').wins(10)
    else
      $ ->
        $('.payout').html('<p>Try again.</p>')
    