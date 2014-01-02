class app.ContactModel extends Backbone.Model
  urlRoot: app.location + "/contacts"

  defaults:
    phoneNumbers: []
    balance: 0
    currency: ""
    lastReason: ""
    lastStatus: ""
    date: null
