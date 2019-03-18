Feature: validate service - common Validations

  Background:
    * def validate = read('../../validate.feature')
    * def msg = call read('../../messages.feature')

    * def option = read('vanillaOption.json')
    * def spot = read('spotForward.json')

  Scenario: check multiply error messages for option

    * def res = call validate {body: '#(option)'}
    And match res.response.messages == '#[5]'
    And match res.response.messages[*] == '#notnull'

  Scenario: check multiply error messages for Spot

    * def res = call validate {body: '#(spot)'}
    And match res.response == read('response/spotForward.json')

  Scenario: check multiply error messages for Forward

    * set spot.type = 'Forward'
    * def res = call validate {body: '#(spot)'}
    And match res.response == read('response/spotForward.json')
