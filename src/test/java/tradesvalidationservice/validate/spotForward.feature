Feature: validate service - Spot, Forward trades validations

  Background:
    * def validate = read('../validate.feature')
    * def msg = call read('../messages.feature')

    * def spotForward = read('spotForward.json')
    * def errorResponse = msg.errorResponseSkipMessage
    * def successResponse = msg.successResponse

  Scenario Outline: Validate the value date against the product type

    * set spotForward.type = <type>
    * set spotForward.tradeDate = <tradeDate>
    * set spotForward.valueDate = <valueDate>

    * def res = call validate {body: '#(spotForward)'}
    And match res.response == <response>

    Examples:
      | type      | tradeDate    | valueDate    | response        | comment                        |
      | 'Spot'    | '2017-08-07' | '2017-08-07' | errorResponse   | 'Spot valueDate = T'           |
      | 'Spot'    | '2017-08-07' | '2017-08-08' | successResponse | 'Spot valueDate = T+1'         |
      | 'Spot'    | '2017-08-07' | '2017-08-09' | successResponse | 'Spot valueDate = T+2'         |
      | 'Spot'    | '2017-08-07' | '2017-08-10' | successResponse | 'Spot valueDate = T+3'         |
      | 'Spot'    | '2017-08-07' | '2017-08-11' | errorResponse   | 'Spot valueDate = T+4'         |
      | 'Spot'    | '2017-08-07' | '2019-08-07' | errorResponse   | 'Spot valueDate = T+1 year'    |
      | 'Forward' | '2017-08-07' | '2017-08-07' | errorResponse   | 'Forward valueDate = T'        |
      | 'Forward' | '2017-08-07' | '2017-08-08' | successResponse | 'Forward valueDate = T+1'      |
      | 'Forward' | '2017-08-07' | '2019-08-07' | successResponse | 'Forward valueDate = T+1 year' |