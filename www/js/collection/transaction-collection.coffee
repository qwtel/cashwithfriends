class app.TransactionCollection extends Backbone.Collection
  url: app.location + '/transactions'

  model: app.TransactionModel

  comparator: "date"

app.transactions = new app.TransactionCollection
