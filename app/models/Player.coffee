class window.Player extends Backbone.Model
  initialize: (params) ->
    if params.name isnt ""
      @set 'name', params.name
    else
      @set 'name', 'The Man With No Name'
    @set 'cash', 200

  bet: (amount) ->
    amount = amount or 10
    cash = @get 'cash'
    @set 'cash', cash - amount

  wins: (amount) ->
    cash = @get 'cash'
    @set 'cash', cash + amount