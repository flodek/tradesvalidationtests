@ignore
Feature: call validate with a body

  Scenario: Validate the value date against the product type

    Given url 'http://127.0.0.1:12345'
    And header Accept = '*/*'
    And path 'validate'
    And request body
    When method post
    Then status 200
