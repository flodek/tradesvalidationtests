Feature: validateBatch spotForward feature

  Background:
    * url 'http://127.0.0.1:12345'
    * header Accept = '*/*'

  Scenario: Validate valid value dates against the product type

    Given path 'validateBatch'
    And request read('spotForwardValid.json')
    When method post
    Then status 200
    And match response == '#[7]'
    And match each response == {status: 'SUCCESS', messages: '#null'}

  Scenario: Validate invalid value dates against the product type

    Given path 'validateBatch'
    And request read('spotForwardInvalid.json')
    When method post
    Then status 200
    And match response == '#[4]'
    And match each response == {status: 'ERROR', messages: '#notnull'}
