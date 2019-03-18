Feature: validateBatch - options style test

  Background:
    * url 'http://127.0.0.1:12345'
    * header Accept = '*/*'

    * def options = read('options.json')

  Scenario: Validate AMERICAN and EUROPEAN styles are valid

    Given path 'validateBatch'
    And request options
    When method post
    Then status 200
    And match response == '#[2]'
    And match each response == {status: 'SUCCESS', messages: '#null'}

  Scenario: Validate invalid value dates against the product type

    * set options[*].style = 'BERMUDA'

    Given path 'validateBatch'
    And request options
    When method post
    Then status 200
    And match response == '#[2]'
    And match each response == {"status":"ERROR","messages":["Invalid option style [ BERMUDA ]. Valid option styles are: [AMERICAN, EUROPEAN]"]}

  Scenario: Validate valid values of exerciseStartDate for AMERICAN style

    Given path 'validateBatch'
    And request read('exerciseStartDateValid.json')
    When method post
    Then status 200
    And match response == '#[2]'
    And match each response == {status: 'SUCCESS', messages: '#null'}

  Scenario: Validate invalid values of exerciseStartDate for AMERICAN style

    Given path 'validateBatch'
    And request read('exerciseStartDateInvalid.json')
    When method post
    Then status 200
    And match response == '#[5]'
    And match each response == {status: 'ERROR', messages: '#notnull'}

  Scenario: Validate valid values of expiryDate and premium date

    Given path 'validateBatch'
    And request read('expiryAndPremiumDateValid.json')
    When method post
    Then status 200
    And match response == '#[2]'
    And match each response == {status: 'SUCCESS', messages: '#null'}

  Scenario: Validate invalid values of expiryDate and premium date

    Given path 'validateBatch'
    And request read('expiryAndPremiumDateInvalid.json')
    When method post
    Then status 200
    And match response == '#[8]'
    And match response == read('response/expiryAndPremiumDateInvalid.json')