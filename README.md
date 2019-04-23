# UMN-Common

## 1.0.8 - 4/15/2019
Added function to return current time in Epoch time, useful for Splunk logging

## 1.0.7 - 4/12/2019
Increased granularity of time in Send-SplunkHEC

## 1.0.6 - 10/15/2018
Added 2 functions Send-SplunkHEC and Get-UsersIDM

## Functions

### Get-WebReqErrorDetails
Get-WebReqErrorDetails takes the  Error thrown by Invoke-Webrequest or Invoke-RestMethod and returns JSON Responsbody data.  This currently only works if the data is JSON.  The reason is to use this is for debugging.  The standard Error response obscures this information and makes it a pain to get at.