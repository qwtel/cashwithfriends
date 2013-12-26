class app.ContactCollection extends Backbone.Collection
  url: app.location + "/contacts"

  model: app.ContactModel

  comparator: (model) -> -model.get("date")

app.contacts = new app.ContactCollection
