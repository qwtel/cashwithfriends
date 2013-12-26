class app.TransactionModel extends Backbone.Model
  urlRoot: app.location + "/transactions"

  defaults:
    from: ""
    to: ""
    balance: 0
    currency: ""
    date: null
    status: ""
