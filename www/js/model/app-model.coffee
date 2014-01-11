class app.AppModel extends Backbone.Model
  defaults:
    id: null
    balance: 0
    currency: "€"
    contacts: []
    #selected: new app.ContactCollection
    #me: new app.ContactModel
    page: ""
    query: ""
    numSelected: 0
    "currency-select": "€"
    "balance-input": 0
    "promise-select": "+"
    "reason-input": ""
    showNextButton: false
    showSearchField: false

  urlRoot: app.location + "/login"

  initialize: -> 
    @listenTo this, "change:page", @updateCollections
    #@get("selected").comparator = "name"

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
      #me = @get("me")
      #me.set id: number
      #me.credentials = @credentials
      #me.fetch()

      #3
      @set("id", number)
      @fetch()

  parse: (t1, t2) ->
    console.log(t1, t2)
    super(t1, t2)

  parseBeforeLocalSave: (t1, t2) ->
    console.log(t1, t2)
    super(t1, t2)

  resetInput: ->
    @set
      "promise-select": @defaults["promise-select"]
      "balance-input": @defaults["balance-input"]
      "currency-select": @defaults["currency-select"]
      "reason-input": @defaults["reason-input"]

  #toJSON: ->
  #  obj = super
  #  _.each _.keys(obj), (key) ->
  #    if obj[key] and not _.isNull(obj[key]) and _.isFunction(obj[key].toJSON)
  #      obj[key] = obj[key].toJSON()
  #  obj

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

  toViewModel: ->
    model = @toJSON()
    model.contacts = _.map model.contacts, (contact) =>
      json = localStorage.getItem(app.location + "/contacts" + contact)
      new app.ContactModel(JSON.parse(json)).toJSON()
    model

app.model = new app.AppModel
