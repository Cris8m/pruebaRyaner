@Operations @bookingOperations
Feature: Booking Operations

  Background:
    * def dataRequest = read('classpath:data/bookingOperations/requestCreateNewBooking.json')
    * def structureError400 = read('classpath:data/structureError.json')
    * def structureResponse = read('classpath:data/bookingOperations/structureResponse200.json')
    * def dateValidator = read('classpath:helpers/dateValidator.js')
    Given url apiUrl
    Given path 'booking'
    Given headers { accept: 'application/json', Content-Type: 'application/json' }


  @newBooking
  Scenario Outline: Validate new booking creation
    * print dataRequest
    And request dataRequest
    When method POST
    Then status 201
    * print response
    And match response == structureResponse
    And match response.date == date
    And match response.destination == destination
    And match response.origin == origin
    And match response.userId == dataRequest.userId
    Examples:
      | date       | destination | origin |
      | 2024-06-10 | MEX         | JFK    |

  @MandatoryFieldsReqValNB
  Scenario Outline: Validate mandatory fields in the request
    * remove dataRequest.<fieldJson>
    * print dataRequest
    And request dataRequest
    When method POST
    Then status 400
    * print response
    And match response == structureError400
    Examples:
      | fieldJson   | date       | destination | origin |
      | date        | 2024-06-10 | MEX         | JFK    |
      | destination | 2024-06-10 | MEX         | JFK    |
      | origin      | 2024-06-10 | MEX         | JFK    |
      | userId      | 2024-06-10 | MEX         | JFK    |

  @reqContValNB
  Scenario Outline:  Validate errors for invalid request content
    * dataRequest.userId = <userId>
    And request dataRequest
    When method POST
    Then status <statusCode>
    * print response
    And match response == structureError400
    Examples:
      | read('classpath:data/bookingOperations/valParmNB.csv') |

  @getAllBookingOK
  Scenario Outline: Validate getting all bookings with and without parameters
    * def query = { user: <user>, date: <date>}
    And params query
    When method GET
    Then status 200
    * print response
    And match each response == structureResponse
    Examples:
      | user | date       |
      | 1    | 2022-02-01 |
      | null | null       |
      | null | 2022-02-01 |
      | 1    | null       |

  @getAllBookingParamKO
  Scenario Outline: Validate errors for invalid parameters
    * def query = { user: <user>, date: <date>}
    And params query
    When method GET
    Then status <statusCode>
    * print response
    And match response == structureError400
    Examples:
      | read('classpath:data/bookingOperations/valParmGetNB.csv') |

  @getAllBookingByIdOK
  Scenario Outline: Validate getting bookings by id
    Given path id
    When method GET
    Then status 200
    * print response
    And match response == structureResponse
    Examples:
      | id |
      | 1  |

  @getAllBookingByIdKO
  Scenario Outline: Validate error for invalid id content
    Given path id
    When method GET
    Then status <statusCode>
    * print response
    And match response == structureError400
    Examples:
      | id   | statusCode |
      | /    | 400        |
      | aaa  | 400        |
      | 1.5  | 400        |
      | 1000 | 404        |
