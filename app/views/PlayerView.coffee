class window.PlayerView extends Backbone.View

  template: _.template '<p class="playerName"><%= name %></p><p class="playerMoney">$<%= cash %></p>'

  initialize: ->
    @render()

    @model.on 'change:cash', =>
      console.log
      @render()

  render: ->
    @$el.children().detach().end().html
    @$el.html @template @model.attributes