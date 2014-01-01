class app.LoginView extends Backbone.View
  tagName: "div"
  className: "modal fade"
  template: Handlebars.compile($("#login-template").html())

  events: 
    "click .btn-primary": "login"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON())).modal backdrop: "static"

  login: ->
    number = @$("#phone-number").val()
    if isValidNumber(number)
      $(".modal-backdrop").remove()

      number = formatE164("US", number).substring(1)
      password = Math.random().toString(36).substring(2)

      localStorage.setItem("number", number)
      localStorage.setItem("password", password)

      @model.credentials = 
        username: number
        password: password
      app.contacts.credentials = @model.credentials
      app.transactions.credentials = @model.credentials

      @readContacts()

      ###
      @model.set 
        id: number
        page: "contacts"

      @model.fetch reset: true
      ###
    else
      @$("#phone-number").parents(".form-group").addClass("has-error")

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
        success: (model, resp, xhr) ->
          # TODO: Store contacts in localStorage
          console.log model
          localStorage.setItem("loginSuccessful", true)

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
