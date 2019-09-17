*** Settings ***
Library    JsonValidator
Library    Collections
Library    BaseFunctions.py
*** Keywords ***
Validate Response From Json File
  [Documentation]  The file should be parsed as dictionary and then key and value pairs should be tested against the response
  [Arguments]  ${Response_Data}  ${file_name}
  ${Verification_Dictionary}  Get Dictionary From Json  ${file_name}
  ${Response_data}  convert to string  ${Response_Data}
  :FOR    ${key}    IN    @{Verification_Dictionary.keys()}
  \    ${value}    Set Variable    ${Verification_Dictionary['${key}']}
  \    ${value_type}    Evaluate    type($value).__name__
  # \    Log    ${value_type}
  \    Log  Actual value for ${key} is being matched with expected value ${value}
  \    Run Keyword If    '${value_type}'=='str'    Element should exist   ${Response_data}    .${key}:expr(x="${value}")
  \    Run Keyword If    '${value_type}'=='int'    Element should exist   ${Response_data}    .${key}:expr(x=${value})
#  \    Run Keyword If    '${value_type}'=='bool'    Element should exist   ${Response_data}    .${key}:expr(x=${value})
  \    Run Keyword If    '${value_type}'=='bool'    Check boolean value   ${Response_data}    ${key}    ${value}

Check boolean value
    [Documentation]  This keyword will accept response and expected key,value pair to match with the actual response
    [Arguments]  ${Response_data}  ${expected_key}  ${expected_value}
    ${all_elements}  Get Elements  ${Response_data}  $.${expected_key}
    Log  ${all_elements}
    @{new_elements}   create list
    :FOR  ${item}  IN  @{all_elements}
    \   ${new_item}  convert to boolean  ${item}
    \   Append To List  ${new_elements}  ${new_item}
#    ${all_value_type}    Evaluate    type($all_elements).__name__
#    Log  ${all_value_type}
#    ${new_item_type}    Evaluate    type($new_item).__name__
#    Log  ${new_item_type}
    ${test_result}  Check If Boolean Match Fails  ${expected_value}  ${new_elements}
    run keyword if  ${test_result}==${false}  Pass Execution  ${expected_value} found in response.
    run keyword unless  ${test_result}==${false}  FAIL  ${expected_value} not found in response.
