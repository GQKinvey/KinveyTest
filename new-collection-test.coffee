###
Copyright (c) 2008-2015, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

# global require, describe, it

chai.should()

#Element
COLLECTION_INPUT_SELECTOR = 'input.form-control'
COLLECTION_CREATE_BUTTON = 'form > button'
VALIDATION_ERROR_MESSAGE = '.validation-error-text'
DROPDOWN_BUTTON = '.icon-caret'
NEW_COLLECTION = '.new-collection'
DATA_SOURCE_LINK =  'ul.data-sources li:eq(0)'

#Strings
COLLECTION_NAME = 'Flower' + Math.round(Math.random() * 100)

##validate error message
checkValidationError = ->
  elem = find(VALIDATION_ERROR_MESSAGE)
  elem.length && elem[0].innerText != ''

##Clearing variable cache
clearValidationError = ->
  elem = find(VALIDATION_ERROR_MESSAGE)
  if elem.length
    elem[0].innerText = ''

describe '/data/collection/:collection_id', ->
  environment = null
  app = null
  collection = null

  before ->
    @timeout 0
    App.reset()

    login().then ->
      createApp().then (_app) ->
        app = _app
        app.get('environments').then (environments) ->
          environment = environments.get('firstObject')
          visit "/environments/#{environment.id}/data/files"

  after ->
    @timeout 0
    deleteApp(app)
    andThen ->
      environment = null
      console.debug("am calling logout")
      logout()


  describe 'Add collection', ->
    it 'should be navigable', ->
      currentURL().should.equal "/environments/#{environment.id}/data/files"

    it 'should have a dropdown to add collection', ->
      @timeout 2000
      find(DROPDOWN_BUTTON).length.should.be.gt 0

    it 'should click dropdown', ->
      click(DROPDOWN_BUTTON)

    it 'should have a link to add collection', ->
      find(NEW_COLLECTION).length.should.equal 1
    
    it 'should click add collection', ->
      click(NEW_COLLECTION)

    describe 'validating collection name', ->
      it 'should validate collection names', ->
        arr = ['%a' ,'a1', 'aa', 'a-', '1a', '-a']
        rxName = /^[a-z][a-z0-9\-]*$/
        ##rxName = /^[0-9a-z\-]+$/
        
        for i in arr
          isError = !rxName.test(i.toLowerCase())
          clearValidationError()
          fillIn COLLECTION_INPUT_SELECTOR, i
          checkValidationError().should.equal isError

    describe 'create collection', ->
      it 'should submit', ->
        fillIn COLLECTION_INPUT_SELECTOR, COLLECTION_NAME
        click(DATA_SOURCE_LINK)
        click(COLLECTION_CREATE_BUTTON)
        @timeout 5000
        andThen ->
          currentURL().should.equal "/environments/#{environment.id}/data/collection/#{COLLECTION_NAME}"

     describe 'create duplicate collection', ->
      it 'should not allow', ->
        visit "/environments/#{environment.id}/data/collections/new"
        clearValidationError
        fillIn COLLECTION_INPUT_SELECTOR, COLLECTION_NAME
        click(COLLECTION_CREATE_BUTTON)
        andThen ->
          checkValidationError().should.equal true