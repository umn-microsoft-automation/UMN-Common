# UMN-Common

## 1.0.14 6/8/2022

Tweak new-password function to allow for no special characters option.

## 1.0.13 - 9/14/2020
Added function 'new-password' which makes use of Scramble-String and Get-RandomCharacter.
This is for generating a random string of characters suitable for passwords.

## 1.0.12 - 6/18/2020
Make Timeout for Get-UsersIDM configurable

## 1.0.11 - 12/10/2019
Fixed bug in Send-SplunkHEC when eventData was a PSCustomObject.
Changed code to make copy of metadata hashtable rather than modifying in place
Renamed Host parameter in Send-SplunkHEC to EventHost (and added alias for backwards compatiblity)

## 1.0.10 - 12/9/2019
Modifed send-SplunkHEC to retry if the initial invoke-restMethod fails

## 1.0.9 - 9/24/2019
Added an optional JsonDepth parameter to Send-SplunkHEC to specify how data is converted to JSON.

## 1.0.8 - 4/15/2019
Added function to return current time in Epoch time, useful for Splunk logging

## 1.0.7 - 4/12/2019
Increased granularity of time in Send-SplunkHEC

## 1.0.6 - 10/15/2018
Added 2 functions Send-SplunkHEC and Get-UsersIDM

## Functions

### Get-WebReqErrorDetails
Get-WebReqErrorDetails takes the  Error thrown by Invoke-Webrequest or Invoke-RestMethod and returns JSON Responsbody data.  This currently only works if the data is JSON.  The reason is to use this is for debugging.  The standard Error response obscures this information and makes it a pain to get at.
