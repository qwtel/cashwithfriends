class app.AppModel extends Backbone.Model
  defaults:
    id: null
    balance: 0
    currency: "€"
    page: ""
    name: ""
    username: ""
    showSearchField: false
    query: ""
    "currency-select": "€"
    "balance-input": 0
    "promise-select": "+"
    "reason-input": ""

  urlRoot: app.location + "/contacts"

  initialize: -> 
    @listenTo this, "change:page", @updateCollections

    app.selected = new app.ContactCollection
    app.selected.comparator = "name"

    number = localStorage.getItem("number")
    password = localStorage.getItem("password")
    if number and password
      @credentials = 
        username: number
        password: password
      app.contacts.credentials = @credentials
      app.transactions.credentials = @credentials

      @set "id", number
      @fetch reset: true
    else
      @set "page", "login"

  resetInput: ->
    @set
      "promise-select": @defaults["promise-select"]
      "balance-input": @defaults["balance-input"]
      "currency-select": @defaults["currency-select"]
      "reason-input": @defaults["reason-input"]

  updateCollections: ->
    page = @get "page"

    switch page
      when "contacts"
        app.contacts.comparator = (model) -> -model.get("date")
        app.contacts.fetch 
          reset: true
          data:
            onlyActive: true

      when "transactions"
        app.transactions.fetch
          reset: true
          data: 
            contact: app.entity.id

      when "addressbook"
        app.contacts.comparator = "name"
        app.contacts.fetch 
          reset: true
          data:
            onlyActive: false

app.model = new app.AppModel
