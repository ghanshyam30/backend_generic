Backend Automation Project
============================
Disclaimer : The project is to be run on linux environment because the "\" creates an issue in windows!

Goals -
============================
1] Payload handling
2] Response handling
3] Setting/ Properties file use
4] Generalizing parameters use

Pre-requisites:
============================
    1] Python 3.7
    2] robotframework
    3] robotframework-requests
    4] robotframework-jsonvalidator

Project Goals Progress -
============================
1] Payload Handling -
       - [Done] Payload should be in a json file in Data folder.
       - [Partial Done] "Get Dictionary From Json" is a keyword which is used in test case along with Json filename as parameter this keyword will return a dictionary form of the payload which needs to be stored in a variable and then used in rest call
            Ex : ${Payload}  Get Dictionary From Json  Post_Create_User
            Payload - Is a variable to store dictionary form of payload
            Post_Create_User is a file name which should be present in Data folder of the project [We need to add one more level of folder like payload and response here]
       - [Pending] Make payload dynamic after getting it's dictionary form, like changing some values.
2] Response Handling -
       - [Done] A keyword which can handle the response validation if a json file of expected key value pairs is passed to it
       - [Info] Library used for response validation is JsonValidator,its documentation can be found in Documentation folder.
       - [Done] A keyword which should be used for validation is -"Validate Response From Json File"
         Example - Validate Response From Json File  ${Post_Response.content}  Post_Create_User
3] Introduce Enviroment Details or Properties file -
       - [Pending] A properties file which gets parsed and used as a general settings for automation run say - base url or port, some global variables etc
       - [Pending] File resides in Data folder of the project, named Environment.properties
4] Generalizing parameters use -
       - [Done] These are just the guidelines which we need to follow while doing the automation.
       - [Info] Headers, path, query parameters should be created in test case itself as those are specific to a test case so no need to make them global except token kind of things
       - [Info] Simple payload having field count upto 5 can also be created in test case itself rather than creating json file.
       - [Usage] ${Headers}  Create Dictionary  Content-Type=application/json - Same way we can create Query,Path parameters as well
5] Example:
Note : You can refer/execute any test from Test\PostTest.robot file to get knowledge of how this works

*** Settings ***
Library  RequestsLibrary
Library  ..\\Code\\BaseFunctions.py
Library    JsonValidator
Resource  ..\\Code\\BaseRobotFunctions.robot

*** Test Cases **
Simple Post Request
  [Documentation]  This is post request execution with custom payload creation and response validation
  [Tags]  POST
  ${base_url}  Set Variable  https://reqres.in
  Create Session  DummyREST  ${base_url}
  ${Headers}  Create Dictionary  Content-Type=application/json
  #${payload}    Create Dictionary  name=DummyUser  job=Associate
  ${Payload}  Get Dictionary From Json  Post_Create_User
  ${Post_Response}  Post Request  DummyREST  /api/users    data=${payload}  headers=${Headers}
  Log  ${Post_Response.content}
  Validate Response From Json File  ${Post_Response.content}  Post_Create_User

