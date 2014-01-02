class app.LoginView extends Backbone.View
  template1: Handlebars.compile($("#login-template").html())
  template2: Handlebars.compile($("#load-contacts-template").html())

  events: 
    "click #btn-register": "register"
    "click #btn-okay": "load"

  initialize: ->
    @render()

  render: ->
    if not localStorage.getItem("registered")
      @render1()
    else if not localStorage.getItem("contactsLoaded")
      @render2()

  render1: ->
    @$el.html(@template1(@model.toJSON())).find(".modal").modal(backdrop: "static")

  render2: ->
    @$el.html(@template2(@model.toJSON())).find(".modal").modal(backdrop: "static")

  register: ->
    number = @$("#phone-number").val()
    if isValidNumber(number)
      #1
      number = formatE164("US", number).substring(1)
      password = Math.random().toString(36).substring(2)

      # 3
      # set all credentials
      @model.credentials = 
        username: number
        password: password
      app.contacts.credentials = @model.credentials
      app.transactions.credentials = @model.credentials

      #5
      me = new app.ContactModel
      me.credentials = @model.credentials
      me.save id: number,
        success: =>
          #1
          console.log("registered")
          localStorage.setItem("number", number)
          localStorage.setItem("password", password)
          localStorage.setItem("registered", true)

          @render2()

        error: (err) => 
          # TODO
          console.log(err)
    else
      @$("#phone-number").parents(".form-group").addClass("has-error")

  load: -> @readContacts()

  contactSuccess: (contacts) ->
    phonebook = new app.ContactCollection
    phonebook.credentials = @model.credentials

    for contact in contacts 
      if contact.phoneNumbers
        validNumbers = []

        for phoneNumber in contact.phoneNumbers
          # FIXME: Simply assuming the country will be Austria.. Lalala... I AM FROM AUSTRIA!!!!11
          dialingCountry = "AT"

          if isValidNumber(phoneNumber.value, dialingCountry)
            validNumber = formatE164(dialingCountry, phoneNumber.value).substring(1)
            validNumbers.push(validNumber)
            console.log validNumber
          else
            console.log "invalid number: " + phoneNumber.value

        if validNumbers.length > 0
          phonebook.add(new app.ContactModel(phoneNumbers: validNumbers))

          localContactData = 
            displayName: contact.displayName
            nickname: contact.nickname

          for number in validNumbers
            key = CryptoJS.SHA256(number)
            localStorage.setItem(key, JSON.stringify(localContactData))

    if phonebook.length > 0
      Backbone.sync 'create', phonebook,
        success: (model, resp, xhr) =>
          # TODO: Store contacts in localStorage
          console.log model
          localStorage.setItem("contactsLoaded", true)

          #2
          $(".modal-backdrop").remove()

          #3
          @model.set page: "contacts"

  contactError: (err) ->
    # TODO
    alert("error")
    console.log(err.toString())

  # TODO: update 
  readContacts: ->
    console.log("read contacts from addressbook")

    options = 
      filter: ""
      multiple: true

    # TODO: make generic function that reads all contact data
    if navigator.contacts
      navigator.contacts.find(["phoneNumbers", "displayName", "nickname"], @contactSuccess, @contactError, options)
    else 
      # XXX: For debugging
      setTimeout =>
        @contactSuccess([
          {
            nickname: "billy"
            phoneNumbers: [{value: "06641234567"}, {value: "0660123456"}]
          }, {
            displayName: "Scott Pilgram"
            phoneNumbers: [{value: "+436643406701"}]
          }
        ])
      , 3000
