class window.AppView extends Backbone.View
  className: 'tableView'
  template: _.template '
    <div class="table">
      <div class="dealer-hand-container"></div>
      <div class="player-hand-container"></div>

      <div class="button-holder">
        <div class="button-box">
          <button class="hit-button">Hit</button>
        </div>
        <div class="button-box">
          <button class="stand-button">Stand</button>
        </div>
        <div class="newGameOptions">
          <button id="startNewGame" style="display:none">Start New Game?</button>
        </div>
      </div>
    </div>

    <div class="playerDeets">
    </div>

    <div class="messagesContainer">
      <div class="messageBox"></div>
      <div class="winnerBox"></div>
      <div class="payout"></div>
    </div>
    <div class="mask"></div>

    '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.endGame()
    "click #startNewGame": -> @model.resetHands()


  initialize: ->
    @askName()
    @render()
    @model.on 'change:winner', =>
      console.log 'appview: winner', this.model.get 'winner'
      @removeButtons()
      @showWinner()
    @model.on 'redraw', =>
      @render()
      @model.checkForBlackJack()
    @model.checkForBlackJack()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.playerDeets').html new PlayerView(model: @model.get 'player').el

  removeButtons: ->
    $ ->
      $('button').attr('disabled', true)
      $('.button-box').fadeOut(300)
      $('.newGameOptions').css({'z-index': 5})
      $('#startNewGame').attr('disabled', false).delay(500).fadeIn(300)

  showWinner: ->
    message = @model.get 'message'
    winner = @model.get 'winner'
    $ ->
      $('.mask').fadeIn 1000, ->
        $('.messagesContainer').fadeIn(500)
    if message
      $ ->
        $('.messageBox').html(message)
    $ ->
      $('.winnerBox').html(winner + ' wins')
    console.log('test')
    @model.payout(winner)

  askName: ->
    this.model.createPlayer prompt "What's your name?"