class app.AppView extends Backbone.View
  el: "#app"

  model: app.model

  template: Handlebars.compile($("#app-template").html())

  initialize: ->
    @listenTo @model, 'reset', @render
    @listenTo @model, 'change:page', @changePage
    @listenTo @model, 'change:query', @renderContacts
    @listenTo app.contacts, 'reset', @renderContacts
    @listenTo app.transactions, 'reset', @renderTransactions
    @listenTo app.transactions, 'add', @addTransaction
    @render()

  render: ->
    console.log "render app"
    @$el.html(@template(@model.toJSON()))
    new app.HeaderView(model: @model, el: "#header")
    new app.FooterView(model: @model, el: "#footer")
    @changePage()

  renderContacts: ->
    @$("#list").empty()

    query = @model.get("query")
    contacts = app.contacts.filter((contact) ->
      contact.get("name").toLowerCase().search(query.toLowerCase()) >= 0
    )

    switch @model.get("page")
      when "contacts"
        _.each contacts, @addContact, this
      when "addressbook"
        _.each contacts, (model) => @add(app.SelectableContactView)(model)

  renderTransactions: ->
    app.transactions.each @addTransaction, this
    $(document).scrollTop($(document).height())

  add: (View, model) ->
    (model) =>
      view = new View(model: model)
      @$("#list").append(view.el)

  addContact: (model) -> @add(app.ContactView)(model)

  addTransaction: (model) -> 
    if @model.get("page") is "transactions"
      @add(app.TransactionView)(model)

  changePage: ->
    @$("#list").empty()

    page = @model.get("page")
    switch page
      when "login"
        view = new app.LoginView(model: @model)
        @$("#list").html(view.el)
      when "adjust"
        _.each app.selected.models, (model) => @add(app.AdjustableContactView)(model)

