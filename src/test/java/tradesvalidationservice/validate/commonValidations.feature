Feature: validate service - common Validations

  Background:
    * def validate = read('../validate.feature')
    * def msg = call read('../messages.feature')

    * def spot = read('spotForward.json')
    * def option = read('vanillaOption.json')

    * def errorResponse = msg.errorResponse
    * def successResponse = msg.successResponse
    * def invalidValueDateMessage = msg.invalidValueDateMessage
    * def nonTradeValueDateMessage = msg.nonTradeValueDateMessage
    * def invalidCustomerMessage = msg.invalidCustomerMessage
    * def invalidCustomerMessage = msg.invalidCustomerMessage
    * def invalidCurrency = msg.invalidCurrency

  Scenario Outline: value date cannot be before trade date
    * set spot.valueDate = <valueDate>
    * set spot.tradeDate = <tradeDate>
    * set option.valueDate = <valueDate>
    * set option.tradeDate = <tradeDate>
    * replace invalidValueDateMessage.valueDate = <valueDate>
    * replace invalidValueDateMessage.tradeDate = <tradeDate>
    * set errorResponse.messages[0] = invalidValueDateMessage

    * def spotResponse = call validate {body: '#(spot)'}
    And match spotResponse.response == <response>

    * set spot.type = 'Forward'
    * def forwardResponse = call validate {body: '#(spot)'}
    And match forwardResponse.response == <response>

    * def optionResponse = call validate {body: '#(option)'}
    And match optionResponse.response == <response>

    Examples:
      | valueDate    | tradeDate    | response        |
      | "2017-08-11" | "2017-08-10" | successResponse |
      | "2017-08-09" | "2017-08-10" | errorResponse   |
      | "2017-08-10" | "2017-08-10" | errorResponse   |

  Scenario Outline: value date cannot fall on weekend or non-working day for currency

    * set spot.valueDate = <valueDate>
    * set spot.ccyPair = <ccyPair>
    * set option.valueDate = <valueDate>
    * set option.ccyPair = <ccyPair>
    * replace nonTradeValueDateMessage.valueDate = <valueDate>
    * set errorResponse.messages[0] = nonTradeValueDateMessage

    * def spotResponse = call validate {body: '#(spot)'}
    And match spotResponse.response == <response>

    * set spot.type = 'Forward'
    * def forwardResponse = call validate {body: '#(spot)'}
    And match forwardResponse.response == <response>

    * def optionResponse = call validate {body: '#(option)'}
    And match optionResponse.response == <response>

    Examples:
      | ccyPair  | valueDate    | response        | comment                          |
      | 'EURUSD' | "2017-08-14" | successResponse | 'Monday'                         |
      | 'EURUSD' | "2017-08-18" | successResponse | 'Friday'                         |
      | 'EURUSD' | "2018-03-08" | successResponse | 'Non working in another country' |
      | 'EURUSD' | "2017-08-19" | errorResponse   | 'Saturday'                       |
      | 'EURUSD' | "2017-08-20" | errorResponse   | 'Sunday'                         |
      | 'EURUSD' | "2018-07-04" | errorResponse   | 'Independent day in the USA'     |
      | 'PLNUSD' | "2018-04-02" | errorResponse   | 'Easter in Poland'               |
      | 'PLNUAH' | "2018-04-09" | errorResponse   | 'Easter in Ukraine'              |

  Scenario Outline: Verify if the counterparty is one of the supported ones (PLUTO1, PLUTO2)

    * set spot.customer = <customer>
    * set option.customer = <customer>
    * replace invalidCustomerMessage.counterparty = <customer>
    * set errorResponse.messages[0] = invalidCustomerMessage

    * def spotResponse = call validate {body: '#(spot)'}
    And match spotResponse.response == <response>

    * set spot.type = 'Forward'
    * def forwardResponse = call validate {body: '#(spot)'}
    And match forwardResponse.response == <response>

    * def optionResponse = call validate {body: '#(option)'}
    And match optionResponse.response == <response>

    Examples:
      | customer | response        |
      | 'PLUTO1' | successResponse |
      | 'PLUTO2' | successResponse |
      | 'PLUTO3' | errorResponse   |
      | ''       | errorResponse   |

  Scenario Outline: CS Zurich is only one legal entity allowed

    * set spot.legalEntity = <legalEntity>
    * set option.legalEntity = <legalEntity>
    * replace invalidCustomerMessage.counterparty = <legalEntity>
    * set errorResponse.messages[0] = invalidCustomerMessage

    * def spotResponse = call validate {body: '#(spot)'}
    And match spotResponse.response == <response>

    * set spot.type = 'Forward'
    * def forwardResponse = call validate {body: '#(spot)'}
    And match forwardResponse.response == <response>

    * def optionResponse = call validate {body: '#(option)'}
    And match optionResponse.response == <response>

    Examples:
      | legalEntity     | response        |
      | 'CS Zurich'     | successResponse |
      | 'NOT Exists'    | errorResponse   |
      | 'CS Singapor'   | errorResponse   |
      | 'CS Luxembourg' | errorResponse   |
      | 'DB Oslo'       | errorResponse   |
      | ''              | errorResponse   |

  Scenario Outline: Validate currencies if they are valid ISO codes

    * set spot.ccyPair = <cur1> + <cur2>
    * set option.ccyPair = <cur1> + <cur2>
    * replace invalidCurrency.ccyPair = <cur1> + <cur2>
    * set errorResponse.messages[0] = invalidCurrency

    * def spotResponse = call validate {body: '#(spot)'}
    And match spotResponse.response == <response>

    * set spot.type = 'Forward'
    * def forwardResponse = call validate {body: '#(spot)'}
    And match forwardResponse.response == <response>

    * def optionResponse = call validate {body: '#(option)'}
    And match optionResponse.response == <response>

    Examples: # checking top currencies
      | cur1  | cur2  | response        |
      | 'EUR' | 'USD' | successResponse |
      | 'JPY' | 'CHF' | successResponse |
      | 'GBP' | 'CAD' | successResponse |
      | 'AUD' | 'NZD' | successResponse |
      | 'ZAR' | 'CNY' | successResponse |
      | 'AUD' | 'EUR' | successResponse |
      | '971' | 'EUR' | errorResponse   |
      | 'EUR' | 'AUR' | errorResponse   |
      | 'EUR' | ''    | errorResponse   |