import os
import json
# from robot.api.deco import keyword
from robot.api import logger
from robot.output.loggerhelper import AbstractLogger as test_logger

class BaseFunctions():

    # INCOMPLETE
    # A fuction to read properties file for the testing environment
    def read_properties_file(self, properties_file_path):
        info_dictionary={}
        return info_dictionary

    # INCOMPLETE
    # A function to read test data file and return to the test
    # It might need some manipulations
    def read_test_data_file(self,data_file_path):
        test_data = {}
        return test_data
    
    # COMPLETE
    # A function which accepts response in bytes and key pattern string and returns the value associated with the given key pattern in response
    def get_value_from_response(self,response,expected_key_pattern):
        # De-serialize the key pattern to apply them separately to the response
        if '.' in expected_key_pattern:
            split_string = expected_key_pattern.split('.')
            #print(split_string)
        print(split_string)

        # convert bytes response to string and then to dictionary 
        bytes_response = response.content                   # Bytes
        string_response = bytes_response.decode("utf-8")    # String
        json_response = json.loads(string_response)         # Dictionary
        
        # iterate response to get the value from key pattern
        for item in split_string:
            json_response = json_response[item]
        
        # Return last value
        return json_response

    # def get_value_from_response(self,response,expected_key_pattern,expected_value):
        
    #     if '.' in expected_key_pattern:
    #         split_string = expected_key_pattern.split('.')
    #         #print(split_string)
    #     print(split_string)
    #     bytes_response = response.content
    #     string_response = bytes_response.decode("utf-8") 
    #     json_response = json.loads(string_response)

    #     for item in split_string:
    #         json_response = json_response[item]
        
    #     # return json_response
    
    # COMPLETE
    # A function which accepts the bytes response and a dictionary of key and values for validation and validates it against the response
    def validate_response(self,bytes_response,verification_dict):
        # Print the response first in report
        logger.info("Response Received:{0}".format(bytes_response))
        string_response = bytes_response.decode("utf-8")        # String response
        json_response = json.loads(string_response)             # Dict response
        self.total_response = json_response                     # Save to instance variable
        logger.info("Validation To be done:{0}".format(verification_dict))
        
        # Separate each key,value pair
        for response_key,response_value in verification_dict.items():
            temp_response = self.total_response
            # Key pattern processing and separating the tree of keys
            if '.' in response_key:
                split_string = response_key.split('.')
            else:
                split_string = response_key
            for item in split_string:
              temp_response = temp_response[item]
            
            # Verification of Expected response value with actually extracted response value
            if str(temp_response) != str(response_value):
                logger.error("Value expected is {0}, but found {1}".format(str(temp_response),str(response_value)))
                test_logger.fail("Values Do Not Match")
    
    # COMPLETE
    # This function accepts the file as input and returns its dictionary format for further use
    def get_dictionary_from_json(self,file_name):
        verification_dictionary = {}        # Temp variable to store the dictionary form of file
        current_dir = os.getcwd()
        with open("{0}\\Data\\{1}.json".format(current_dir,file_name)) as json_file:
            verification_dictionary = json.load(json_file)
        return verification_dictionary

    #COMPLETE
    # This function is to asssist JasonValidator library as it can not validate the boolean data due to difference between the boolean syntax
    # This function will check actual and expected boolean value and raise the flag if found different
    def check_if_boolean_match_fails(self, expected_val, actual_val_list):
        flag = False        #   Flag to be raised if match fails
        if expected_val in actual_val_list:
            logger.info("Value varified successfully")
            flag = False
        else:
            logger.error("Value not found in actual response : {0}".format(expected_val))
            flag = True
        return flag

