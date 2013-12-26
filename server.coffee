# Use this to serve the contents of the www directory
#
# Usage:
# npm install express
# node server.js
#
# Install the Ripple Emulator extension for Chrome: 
# https://chrome.google.com/webstore/detail/ripple-emulator-beta/geelfhphabnejjhdalkjhgipohgpdnoc/details
#
# Point Chrome to localhost:3000

express = require 'express'
app = express()

app.use express.static('www')
app.use express.bodyParser()

app.get '/contacts', (req, res) ->
  contacts = [
    id: "1"
    name: "Florian Klampfer"
    username: "cell303"
    balance: 10.02
    currency: "€"
    reason: "pizza"
    status: "ok"
    date: new Date().getTime() - 300000000
  ,
    id: "2"
    name: "Alexander Magnus Partsch"
    username: "alexander.m.partsch"
    balance: -10.00
    currency: "€"
    reason: "some pretty long reason for pizza"
    status: "rejected"
    date: new Date().getTime() - 123456700
  ,
    id: "3"
    name: "Horst Müller"
    username: "horst.mueller"
    balance: 16.61
    currency: "€"
    reason: "pizza"
    status: "pending"
    date: new Date().getTime() - 10000
  ]

  if req.query.onlyActive is "false"
    contacts.push
      id: "4"
      name: "Bob"
      username: "bob"
      balance: 0
    contacts.push
      id: "5"
      name: "Sam"
      username: "sam"
      balance: 0

  res.send contacts

app.get "/transactions", (req, res) ->
  if req.query.contact is "3"
    res.send [
      id: "1"
      from: "XXXme"
      to: "3"
      reason: "for pizza"
      balance: 6.5
      currency: "€"
      status: "ok"
      date: new Date().getTime() - 10000000
    ,
      id: "2"
      from: "3"
      to: "XXXme"
      reason: "forgot what it was"
      balance: 3.5
      currency: "€"
      status: "ok"
      date: new Date().getTime() - 1000000
    ,
      id: "3"
      from: "XXXme"
      to: "3"
      reason: "1 bubblegum lol"
      balance: 0.11
      currency: "€"
      status: "ok"
      date: new Date().getTime() - 100000
    ,
      id: "5"
      balance: -3.00
      currency: "€"
      status: "generated"
      date: new Date().getTime() - 99999
      name1: "Sam"
      name2: "Bob"
      numIntermediates: 2
    ,
      id: "4"
      from: "3"
      to: "XXXme"
      reason: "pizza"
      balance: 6.50
      currency: "€"
      status: "pending"
      date: new Date().getTime() - 10000
    ]
  else res.send []

app.put "/transactions/:id", (req, res) ->
  res.send status: req.body.status

id = 5
app.post "/transactions", (req, res) ->
  res.send
    status: "pending"
    date: new Date().getTime()
    id: id++

app.get "/login", (req, res) ->
  res.send
    id: "asdf"
    balance: 10.13
    currency: "€"
    page: "contacts"

app.listen 3000
