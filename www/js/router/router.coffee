class Router extends Backbone.Router
  routes:
    ":page": "setPage"
    "": "home"

  setPage: (page, id) ->
    id = id or null
    app.model.set("page", page)

  home: -> 
    @setPage "login"

app.router = new Router();
Backbone.history.start()
