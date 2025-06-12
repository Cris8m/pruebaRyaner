# Automated Testing Project with Karate

## Project Structure
```
pruebaRyaner/
├── src/
│ └── test/
│ ├── java/
│ │ ├── runnerUser.java # Main runner for executing tests (JUnit + Karate)
│ │ ├── bookingOperations/ # Feature files for booking-related scenarios
│ │ │ └── createBooking.feature # Booking feature with scenarios and backgrounds
│ │ └── userOperations/ # Feature files for user-related scenarios
│ │ └── createUser.feature # User feature for creating users
│ └── resources/
│ └── data/
│ ├── bookingOperations/ # JSON/CSV test data for booking features
│ │ ├── requestCreateNewBooking.json # Request body for booking creation
│ │ ├── structureResponse200.json # Expected 200 OK response structure
│ │ ├── structureError.json # Expected error structure for 4xx cases
│ │ ├── valParmNB.csv # CSV with invalid parameters (negative tests)
│ │ └── valParmGetNB.csv # CSV with invalid GET params
│ └── userOperations/ # JSON/CSV test data for user features
│ └── helpers/ # JS helper functions for validations
│ └── dateValidator.js # JS function to validate date formats
├── target/
│ └── karate-reports/
│ └── karate-summary.html # Summary report generated after Karate test execution
```

- **Features:** `.feature` files are organized in the `operations` folder by domain (users, bookings, etc.).
- **Test Data:** JSON files for test data and validation structures are in `src/test/resources/data`.
- **Runner:** The Java file to execute tests is `runnerUser.java`.
- **Helpers:** JavaScript helper functions for custom validations.
- **karate-summary.html:** Summary report automatically generated after running Karate tests. Located in `target/karate-reports/`.


## Prerequisites

- **Java:** 21.0.3 (2024-04-16 LTS)
- **Apache Maven:** 3.9.6
- **Git:** For cloning and managing the repository
- **Recommended IDE:** IntelliJ IDEA (or Visual Studio Code)
- **Recommended IDE Extensions/Plugins:**
  - Cucumber for Java
  - Karate
  - JUnit
  - Gherkin

Ensure you have these versions and extensions installed for proper execution and editing of automated tests.

## Test Execution

- **From IntelliJ IDEA:**
  1. Open the project in IntelliJ.
  2. Run the `runnerUser.java` class as a JUnit test.
  3. You can modify the tag in the line `.tags("@Operations")` to execute the desired set of tests.
     - The `@Operations` tag runs all main features in the project.
     - To run only a subset, change the tag to match your test needs.

- **Test Report:**
  - After execution, the IntelliJ terminal will print a link to the generated HTML report.
    For example:  
   ```
    HTML report: (paste into browser to view) | Karate version: 1.5.0
   file:///C:/Users/Documents/pruebaRyaner/target/karate-reports/karate-summary.html
    ```
  - Click or copy and paste this link into your browser to view the test results summary.
  - The report is saved in the target folder. In addition, this repository contains the PDF versions of the report obtained after the first test execution I performed.


## Test Framework and Test Design Choices
- **Framework Selection:**  
  This project uses [Karate](https://github.com/karatelabs/karate) as the main test framework due to its readable Gherkin syntax, seamless integration with Java/JUnit, support for data-driven testing, and the ability to include JavaScript helper functions. Karate enables expressive, maintainable, and scalable API tests.

- **Test Implementation:**  
  Tests are designed based on the API contract (Swagger/OpenAPI) to cover a wide range of scenarios including positive flows, mandatory field validations, handling invalid inputs, and error responses.  
  For example, booking tests include creating new bookings, verifying mandatory fields, testing with invalid parameters (in both requests and query parameters), and retrieving bookings by ID.  
  Test data is externalized in JSON and CSV files to facilitate data-driven testing, allowing multiple cases to be validated without duplicating code. Dynamic data is generated when necessary to avoid conflicts between executions.  
  Tests leverage Karate matchers to strictly validate response structures, HTTP status codes, and business rules, ensuring robustness and compliance with API specifications.
