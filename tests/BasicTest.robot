*** Settings ***
Library  RequestsLibrary
Library  ..//code//BaseFunctions.py
Library  JsonValidator
Resource  ..//code//BaseRobotFunctions.robot

*** Test Cases ***
Simple Get Request
  ${base_url}  Set Variable  https://reqres.in
  Create Session  DummyREST  ${base_url}
  ${Get_Response}  Get Request  DummyREST  /api/users/2
  Log  ${Get_Response.content}
  ${expected_email}  Set Variable  janet.weaver@reqres.in
  ${actual_email}  Get Value From Response  ${Get_Response}  data.email
  Should Be Equal  ${actual_email}  ${expected_email}

# Simple Post Request
#   ${base_url}  Set Variable  https://reqres.in
#   Create Session  DummyREST  ${base_url}
#   ${payload}    Create Dictionary  name=DummyUser  job=Associate
#   ${Post_Response}  Post Request  DummyREST  /api/users    data=${payload}
#   Log  ${Post_Response.content}

Get Request With Response Dict
  ${base_url}  Set Variable  https://reqres.in
  Create Session  DummyREST  ${base_url}
  ${Expected_Resp_Dict}  Create Dictionary  data.last_name=Weaver  data.email=ghana.weaver@reqres.in
  ${Get_Response}  Get Request  DummyREST  /api/users/2
  Log  ${Get_Response.content}
  Validate Response  ${Get_Response.content}  ${Expected_Resp_Dict}

Get Request With Response Validation Value Approach
  [Documentation]  This test case is for response validation purpose, Notice Element should exist keyword and it needs JsonValidator Library in settings
  [Tags]  New
  ${base_url}  Set Variable  https://reqres.in
  Create Session  DummyREST  ${base_url}
  # ${Expected_Resp_Dict}  Create Dictionary  data.last_name=Weaver  data.email=ghana.weaver@reqres.in
  ${Get_Response}=  Get Request  DummyREST  /api/users
  Log  ${Get_Response.content}
  ${key}  Set Variable  total_pages
  ${value}  Set Variable  4
  Element should exist  ${Get_Response.content}  .${key}:expr(x=4)
  Element should exist  ${Get_Response.content}  .data..first_name:expr(x="Gorge")
  #Validate Response  ${Get_Response.content}  ${Expected_Resp_Dict}

Get Request With Response Validation Value Approach
  [Documentation]  This test case is for response validation purpose, Notice Element should exist keyword and it needs JsonValidator Library in settings
  [Tags]  NewOne
  ${base_url}  Set Variable  https://reqres.in
  Create Session  DummyREST  ${base_url}
  # ${Expected_Resp_Dict}  Create Dictionary  data.last_name=Weaver  data.email=ghana.weaver@reqres.in
  ${Get_Response}=  Get Request  DummyREST  /api/users
  Log  ${Get_Response.content}
  Validate Response From Json File  ${Get_Response.content}  resp1
  #Validate Response  ${Get_Response.content}  ${Expected_Resp_Dict}
