Feature: validate service - vanillaOption feature

  Background:
    * def validate = read('../validate.feature')
    * def msg = call read('../messages.feature')

    * def option = read('vanillaOption.json')
    * def successResponse = msg.successResponse
    * def errorResponse = msg.errorResponse
    * def errorResponseSkipMessage = msg.errorResponseSkipMessage
    * def invalidOptionStyle = msg.invalidOptionStyle
    * def invalidExpiryDate = msg.invalidExpiryDate
    * def invalidPremiumDate = msg.invalidPremiumDate

  Scenario Outline: The style can be either American or European

    * set option.style = <style>
    * eval if (<style> == 'AMERICAN') option.exerciseStartDate = "2017-08-12"
    * replace invalidOptionStyle.style = <style>
    * set errorResponse.messages[0] = invalidOptionStyle

    * def res = call validate {body: '#(option)'}
    And match res.response == <response>

    Examples:
      | style      | response        |
      | 'EUROPEAN' | successResponse |
      | 'AMERICAN' | successResponse |
      | 'BERMUDA'  | errorResponse   |
      | ''         | errorResponse   |


  Scenario: Check an Error returned if exerciseStartDate is not presented for American style

    * set option.style = 'AMERICAN'

    * def res = call validate {body: '#(option)'}
    And match res.response == errorResponseSkipMessage


  Scenario Outline:  exerciseStartDate has to be after the trade date but before the expiry date

    * set option.style = 'AMERICAN'
    * set option.tradeDate = <tradeDate>
    * set option.exerciseStartDate = <exerciseStartDate>
    * set option.expiryDate = <expiryDate>
    * set option.deliveryDate = "2019-04-01"

    * def res = call validate {body: '#(option)'}
    And match res.response == <response>

    Examples:
      | tradeDate    | exerciseStartDate | expiryDate   | response                 |
      | "2019-03-20" | "2019-03-21"      | "2019-03-27" | successResponse          |
      | "2019-03-20" | "2019-03-26"      | "2019-03-27" | successResponse          |
      | "2019-03-20" | "2019-03-20"      | "2019-03-27" | errorResponseSkipMessage |
      | "2019-03-20" | "2019-03-27"      | "2019-03-27" | errorResponseSkipMessage |
      | "2019-03-20" | "2019-03-19"      | "2019-03-27" | errorResponseSkipMessage |
      | "2019-03-20" | "2019-03-28"      | "2019-03-27" | errorResponseSkipMessage |


  Scenario Outline: ExpiryDate and premium date shall be before deliveryDate

    * set option.expiryDate = <expiryDate>
    * set option.premiumDate = <premiumDate>
    * set option.deliveryDate = <deliveryDate>

    * def res = call validate {body: '#(option)'}
    And match res.response == <response>

    Examples:
      | expiryDate   | premiumDate  | deliveryDate | response                                                                                              |
      | "2019-03-26" | "2019-03-26" | "2019-03-27" | successResponse                                                                                       |
      | "2019-03-27" | "2019-03-26" | "2019-03-27" | {"status":"ERROR","messages":["Expiry date 2019-03-27 has to be before delivery date 2019-03-27 "]}   |
      | "2019-03-26" | "2019-03-27" | "2019-03-27" | {"status":"ERROR","messages":["Premium date 2019-03-27 has to be before delivery date 2019-03-27  "]} |
      | "2019-03-28" | "2019-03-26" | "2019-03-27" | {"status":"ERROR","messages":["Expiry date 2019-03-28 has to be before delivery date 2019-03-27 "]}   |
      | "2019-03-26" | "2019-03-28" | "2019-03-27" | {"status":"ERROR","messages":["Premium date 2019-03-28 has to be before delivery date 2019-03-27  "]} |
