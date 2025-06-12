@Operations @userOperations
Feature: Creación de usuarios

  Background:
    * def dataRequest = read('classpath:data/userOperations/requestCreateUser.json')
    * def structureError400 = read('classpath:data/structureError.json')
    * def structureResponse = read('classpath:data/userOperations/structureResponse200.json')
    Given url apiUrl
    Given path 'user'
    Given headers { accept: 'application/json', Content-Type: 'application/json' }


  @createUser
  Scenario Outline: Validate user creation
    And request dataRequest
    When method POST
    Then status 201
    * print response
    And match response == structureResponse
    And match response.email == email
    And match response.name == name
    And match response.surname == surname
    Examples:
      | email               | name  | surname |
      | m12@gmail.com       | Mario | Rossi   |
      | a34@test.es         | Ana   | López   |
      | pedro56@hotmail.com | Pedro | Ramírez |


  @validateMandatoryParamsCU
  Scenario Outline: Validate mandatory fields
    * remove dataRequest.<fieldJson>
    * print dataRequest
    And request dataRequest
    When method POST
    Then status 400
    * print response
    And match response == structureError400
    Examples:
      | fieldJson | email              | name | surname |
      | email     | aslopez@mail.com   | A    | López   |
      | name      | asdlopez@mail.com  | A    | López   |
      | surname   | asdflopez@mail.com | A    | López   |

  @validateParmContentCU
  Scenario Outline: Validate parameter content errors
    And request dataRequest
    When method POST
    Then status <statusCode>
    * print response
    And match response == structureError400
    Examples:
      | read('classpath:data/userOperations/valParmCU.csv') |

  @getAllUsersOK
  Scenario: Validate getting all users
    When method GET
    Then status 200
    * print response
    And match each response == structureResponse

  @getAllUsersKO
  Scenario Outline: Validate error response
    And request dataRequest
    When method GET
    Then status 400
    * print response
    And match response == structureError400
    Examples:
      | email            | name  | surname |
      | prueba@gmail.com | Mario | Rossi   |

  @getUserByIdOK
  Scenario Outline: Validate getting user by ID
    Given path id
    When method GET
    Then status 200
    * print response
    And match response == structureResponse
    Examples:
      | id |
      | 1  |
      | 2  |

  @getUserByIdKO
  Scenario Outline: Validate ID content error
    Given path id
    When method GET
    Then status <statusCode>
    * print response
    And match response == structureError400
    Examples:
      | id  | statusCode |
      | /   | 400        |
      | aaa | 400        |
      | 1.5 | 400        |
      | 100 | 404        |

  @integration
  Scenario Outline: Integration test for all Create User endpoints
    And request dataRequest
    When method POST
    Then status 201
    * def responseNewUser = response
    * print responseNewUser
    * def idd = responseNewUser.id
    * print idd
    * def userList = call read('@getAllUsersOK')
    * def RespAllUsers = userList.response
    * print RespAllUsers
    * match RespAllUsers contains responseNewUser
    Given path 'user',idd
    When method GET
    Then status 200
    * print response
    * match responseNewUser == response
    Examples:
      | email             | name  | surname |
      | pppp1@hotmail.com | Mario | Rossi   |
