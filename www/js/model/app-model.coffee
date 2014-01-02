class app.AppModel extends Backbone.Model
  defaults:
    #id: null
    #balance: 0
    #currency: "€"
    page: ""
    showSearchField: false
    query: ""
    contacts: new app.ContactCollection
    selected: new app.ContactCollection
    numSelected: 0
    me: new app.ContactModel
    "currency-select": "€"
    "balance-input": 0
    "promise-select": "+"
    "reason-input": ""
    showNextButton: false
    showSearchField: false

  urlRoot: app.location + "/contacts"

  initialize: -> 
    @listenTo this, "change:page", @updateCollections
    @get("selected").comparator = "name"

    # TODO remove
    #app.selected = new app.ContactCollection
    #app.selected.comparator = "name"

    number = localStorage.getItem("number")
    password = localStorage.getItem("password")
    registered = localStorage.getItem("registered")

    if registered and number and password
      @credentials = 
        username: number
        password: password
      #app.contacts.credentials = @credentials
      #app.transactions.credentials = @credentials

      #2 
      me = @get("me")
      me.set id: number
      me.credentials = @credentials
      me.fetch()

      #3
      @get("contacts").fetch()

  resetInput: ->
    @set
      "promise-select": @defaults["promise-select"]
      "balance-input": @defaults["balance-input"]
      "currency-select": @defaults["currency-select"]
      "reason-input": @defaults["reason-input"]

  toJSON: ->
    obj = super
    _.each _.keys(obj), (key) ->
      if obj[key] and not _.isNull(obj[key]) and _.isFunction(obj[key].toJSON)
        obj[key] = obj[key].toJSON()
    console.log obj
    obj

  updateCollections: ->
    page = @get "page"

    ###
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
    ###

app.model = new app.AppModel
