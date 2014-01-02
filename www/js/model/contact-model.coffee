class app.ContactModel extends Backbone.Model
  urlRoot: app.location + "/contacts"

  defaults:
    id: null
    phoneNumbers: []
    balance: 0
    currency: ""
    #lastReason: ""
    #lastStatus: ""
    date: null
    transactions: new app.TransactionCollection
