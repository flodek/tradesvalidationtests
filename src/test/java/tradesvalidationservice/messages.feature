@ignore
Feature: call validate with a body

  Background:
    #strings are not formatted in the same way (spaces, brackets). Skipping this since there is nothing regarding the messages in the requirements
    * def errorResponse = {"status":"ERROR","messages":[""]}
    * def errorResponseSkipMessage = {status: 'ERROR', messages: '#notnull'}
    * def successResponse = {"status":"SUCCESS","messages":null}
    * def invalidCustomerMessage = "Counterparty [<counterparty>] is not supported. Supported counterparties: [[PLUTO2, PLUTO1]]"
    * def invalidValueDateMessage = "Value date <valueDate> cannot be null and it has to be after trade date <tradeDate> "
    * def nonTradeValueDateMessage = "Value date [<valueDate>] cannot fall on Saturday/Sunday"
    * def invalidCurrency = "Invalid currency pair [<ccyPair>]"
    * def invalidOptionStyle = "Invalid option style [ <style> ]. Valid option styles are: [AMERICAN, EUROPEAN]"
    * def invalidPremiumDate = "Premium date <premiumDate> has to be before delivery date <deliveryDate> "
    * def invalidExpiryDate = "Expiry date <expiryDate> has to be before delivery date <deliveryDate> "

  Scenario: Initializing messages

