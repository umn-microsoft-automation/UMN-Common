# UMN-Common

## Functions

### Get-WebReqErrorDetails
Get-WebReqErrorDetails takes the  Error thrown by Invoke-Webrequest or Invoke-RestMethod and returns JSON Responsbody data.  This currently only works if the data is JSON.  The reason is to use this is for debugging.  The standard Error response obscures this information and makes it a pain to get at.