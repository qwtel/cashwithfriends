class app.AppView extends Backbone.View
  el: "#app"

  model: app.model

  template: Handlebars.compile($("#app-template").html())

  initialize: ->
    @listenTo @model, 'reset', @render
    @listenTo @model, 'change:page', @renderPage
    @listenTo @model, 'change:query', @renderPage
    #@listenTo app.contacts, 'reset', @contactsReceived
    #@listenTo app.transactions, 'reset', @renderTransactions
    @listenTo app.transactions, 'add', @addTransaction

    @render()

  render: ->
    console.log "render app"

    @$el.html(@template(@model.toJSON()))
    new app.HeaderView(model: @model, el: "#header")
    new app.FooterView(model: @model, el: "#footer")

    if !localStorage.getItem("registered") or !localStorage.getItem("contactsLoaded")
      @model.set page: "login"
    else
      @model.set page: "contacts"

    @renderPage()

  renderTransactions: (transactions) ->
    transactions.each @addTransaction, this
    $(document).scrollTop($(document).height())

  add: (View, model) ->
    (model) =>
      view = new View(model: model)
      @$("#list").append(view.el)

  addContact: (model) -> @add(app.ContactView)(model)

  addTransaction: (model) -> 
    if @model.get("page") is "transactions"
      @add(app.TransactionView)(model)

  renderPage: ->
    console.log("change page")
    @$("#list").empty()

    switch @model.get("page")
      when "login"
        view = new app.LoginView(model: @model)
        @$("#list").html(view.el)
      when "contacts"
        contacts = @filterContacts @model.get("contacts")
        _.each contacts, @addContact, this
      when "addressbook"
        contacts = @filterContacts @model.get("contacts")
        _.each contacts, (model) => @add(app.SelectableContactView)(model)
      when "adjust"
        @model.get("selected").each (model) => @add(app.AdjustableContactView)(model)

  filterContacts: (contacts) ->
    console.log("filter contacts", contacts)

    page = @model.get("page")
    query = @model.get("query")
    contacts.filter (contact) =>
      filter = true
      #contact.get("nickname").toLowerCase().search(query.toLowerCase()) >= 0
      if page is "contacts" then filter = filter and contact.get("transactions").length > 0
      filter
