###
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements.  See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership.  The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License.  You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied.  See the License for the
* specific language governing permissions and limitations
* under the License.
###

Handlebars.registerHelper "equals", (field, value) -> field is value

Handlebars.registerHelper "timeago", (date) -> 
  #moment(date).format('llll') #.fromNow()
  moment(date).format('L')

Handlebars.registerHelper "fixed", (number) -> 
  number.toFixed(2)

Handlebars.registerHelper "sign", (number) -> 
  number = Handlebars.helpers.fixed(number)
  if number > 0 then "+" + number
  else number

Handlebars.registerHelper "color", (number) -> 
  if number > 0 then "green"
  else if number < 0 then "red"
  else ""

Handlebars.registerHelper "ows", (number) -> 
  if number > 0 then "ows you"
  else if number < 0 then "you owe"
  else ""

Handlebars.registerHelper "glyphicon", (status) ->
  switch status
    when "ok" then "glyphicon-ok"
    when "pending" then "glyphicon-time"
    when "rejected" then "glyphicon-remove"
    when "inflight" then "glyphicon-send"
    when "generated" then "glyphicon-info-sign"

_.extend app,
  initialize: -> 
    @bindEvents()

  bindEvents: ->
    document.addEventListener('deviceready', this.onDeviceReady, false);

    # TODO: Move this to onDeviceReady in production!
    app.view = new app.AppView();

    window.fbAsyncInit = =>
      FB.init
        appId      : '254645454692956'
        status     : true  # check login status
        cookie     : true  # enable cookies to allow the server to access the session
        xfbml      : true  # parse XFBML

      FB.Event.subscribe 'auth.authResponseChange', (response) =>
        if response.status is 'connected'
          app.model.set "page", "contacts"
          #app.model.set "page", "login"
        else
          app.model.set "page", "login"

  onDeviceReady: -> 
