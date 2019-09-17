*** Settings ***
Library  RequestsLibrary
Library  ..//code//BaseFunctions.py
Library    JsonValidator
Resource  ..//code//BaseRobotFunctions.robot

*** Test Cases ***
Simple Get Request
  [Documentation]  This is simple get request execution test using robot framework requests library
  [Tags]  GET
  ${base_url}  Set Variable  https://reqres.in
  Create Session  DummyREST  ${base_url}
  ${Get_Response}  Get Request  DummyREST  /api/users/2
  Log  ${Get_Response.content}
  ${expected_email}  Set Variable  janet.weaver@reqres.in
  ${actual_email}  Get Value From Response  ${Get_Response}  data.email
  Should Be Equal  ${actual_email}  ${expected_email}

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

Weather Post Request
    [Documentation]  This is post request execution with custom payload creation and response validation
    [Tags]  weather
    ${base_url}    Set Variable    http://api.openweathermap.org
    log    ${base_url}
    Create Session    REST_TEST    ${base_url}
    #${Headers}  Create Dictionary  Content-Type=application/json
    #${payload}    Create Dictionary  name=DummyUser  job=Associate
    #${Payload}  Get Dictionary From Json  Post_Create_User
    ${Post_Response}    Get Request    REST_TEST    /data/2.5/weather?q=pune,IN&APPID=cfd738db770066f6c9cf8175c6e23095
    Log    ${Post_Response.content}
    Validate Response From Json File    ${Post_Response.content}    response_weather

