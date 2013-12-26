class app.LoginView extends Backbone.View
  tagName: "span"
  template: Handlebars.compile($("#login-template").html())

  initialize: ->
    @render()

  events:
    "click .btn-facebook": "login"

  render: ->
    @$el.html(@template(@model.toJSON()))

  login: -> FB.login()
