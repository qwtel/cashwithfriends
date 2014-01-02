class app.SelectableContactView extends app.ContactView
  initialize: ->
    super
    selected = app.model.get("selected")
    @model.set("isSelected", selected.contains(@model))

  render: ->
    super
    isSelected = @model.get("isSelected") or false
    @$el.toggleClass("active", isSelected)

  click: ->
    isSelected = @model.get("isSelected") or false
    @model.set("isSelected", !isSelected)

    selected = app.model.get("selected")
    if isSelected is false
      selected.add(@model)
    else 
      selected.remove(@model)

    app.model.set("numSelected", selected.length)
