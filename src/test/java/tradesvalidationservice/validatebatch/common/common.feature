Feature: ValidateBatch - common feature

  Background:
    * url 'http://127.0.0.1:12345'
    * header Accept = '*/*'

    * def batch = read('allProducts.json')
    * def errorResponse = {"status":"ERROR","messages":[""]}
    * def successResponse = {"status":"SUCCESS","messages":null}
    * def invalidCustomerMessage = "Counterparty [<counterparty>] is not supported. Supported counterparties: [[PLUTO2, PLUTO1]]"
    * def invalidValueDateMessage = "Value date <valueDate> cannot be null and it has to be after trade date <tradeDate> "
    * def nonTradeValueDateMessage = "Value date [<valueDate>] cannot fall on Saturday/Sunday"
    * def invalidCurrency = "Invalid currency pair [<ccyPair>]"

  Scenario Outline: Value date cannot be before trade date

    * set batch[*].valueDate = <valueDate>
    * set batch[*].tradeDate = <tradeDate>
    * replace invalidValueDateMessage.valueDate = <valueDate>
    * replace invalidValueDateMessage.tradeDate = <tradeDate>

    * set errorResponse.messages[0] = invalidValueDateMessage

    Given path 'validateBatch'
    And request batch
    When method post
    Then status 200
    And match response == '#[4]'
    And match each response == <response>

    Examples:
      | valueDate    | tradeDate    | response        |
      | "2017-08-11" | "2017-08-10" | successResponse |
      | "2017-08-10" | "2017-08-10" | successResponse |
      | "2017-08-09" | "2017-08-10" | errorResponse   |

  Scenario Outline: Value date cannot fall on weekend or non-working day for currency

    * set batch[*].valueDate = <valueDate>
    * set batch[*].ccyPair = <ccyPair>
    * replace nonTradeValueDateMessage.valueDate = <valueDate>
    * set errorResponse.messages[0] = nonTradeValueDateMessage

    Given path 'validateBatch'
    And request batch
    When method post
    Then status 200
    And match response == '#[4]'
    And match each response == <response>

    Examples:
      | ccyPair  | valueDate    | response        | comment                          |
      | 'EURUSD' | "2017-08-14" | successResponse | 'Monday'                         |
      | 'EURUSD' | "2017-08-18" | successResponse | 'Friday'                         |
      | 'EURUSD' | "2018-03-08" | successResponse | 'Non working in another country' |
      | 'EURUSD' | "2017-08-19" | errorResponse   | 'Saturday'                       |
      | 'EURUSD' | "2017-08-20" | errorResponse   | 'Sunday'                         |
      | 'EURUSD' | "2018-07-04" | errorResponse   | 'Independent day in USA'         |
      | 'PLNUSD' | "2018-04-02" | errorResponse   | 'Easter in Poland'               |
      | 'PLNUAH' | "2018-04-09" | errorResponse   | 'Easter in Ukraine'              |

  Scenario Outline: Supported counterparties are PLUTO1 and PLUTO2

    * set batch[*].customer = <customer>
    * replace invalidCustomerMessage.counterparty = <customer>
    * set errorResponse.messages[0] = invalidCustomerMessage

    Given path 'validateBatch'
    And request batch
    When method post
    Then status 200
    And match response == '#[4]'
    And match each response == <response>

    Examples:
      | customer | response        |
      | 'PLUTO1' | successResponse |
      | 'PLUTO2' | successResponse |
      | 'PLUTO3' | errorResponse   |

  Scenario Outline: CS Zurich is only one legal entity allowed

    * set batch[*].legalEntity = <legalEntity>
    * replace invalidCustomerMessage.counterparty = <legalEntity>
    * set errorResponse.messages[0] = invalidCustomerMessage

    Given path 'validateBatch'
    And request batch
    When method post
    Then status 200
    And match response == '#[4]'
    And match each response == <response>

    Examples:
      | legalEntity     | response        |
      | 'CS Zurich'     | successResponse |
      | 'NOT Exists'    | errorResponse   |
      | 'CS Singapor'   | errorResponse   |
      | 'CS Luxembourg' | errorResponse   |
      | 'DB Oslo'       | errorResponse   |

  Scenario Outline: Validate currencies if they are valid ISO codes

    * set batch[*].ccyPair = <cur1> + <cur2>
    * replace invalidCurrency.ccyPair = <cur1> + <cur2>
    * set errorResponse.messages[0] = invalidCurrency

    Given path 'validateBatch'
    And request batch
    When method post
    Then status 200
    And match response == '#[4]'
    And match each response == <response>

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

