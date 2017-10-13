##############################
#.SYNOPSIS
#Azure Powershell Runbook to resolve a request within Service Manager on a Hornbill Instance
#
#.DESCRIPTION
#Azure Powershell Runbook to resolve a request within Service Manager on a Hornbill Instance
#
#.PARAMETER instanceName
#MANDATORY: The name of the Instance to connect to.
#
#.PARAMETER instanceKey
#MANDATORY: An API key with permission on the Instance to carry out the required API calls.
#
#.PARAMETER instanceZone
#MANDATORY: The zone in which the instance resides:
# - eur : Europe zone
# - nam : North American zone
#
#.PARAMETER requestReference
#MANDATORY: The request reference ID
#
#.PARAMETER resolutionText
#MANDATORY: The closure text string
#
#.PARAMETER updateVisibility
#The visibility of the closure timeline update. Defaults to "trustedGuest"
#
#.PARAMETER closureCategoryId
#The closure category code
#
#.PARAMETER closureCategoryName
#The closure category full name
#
#.NOTES
#Modules required to be installed on the Automation Account this runbook is called from:
# - HornbillAPI
###############################
workflow Hornbill_RequestResolve_Workflow
{
    # Define Output stream type
    [OutputType([object])]

    # Define runbook input params
    Param
    (
        # Instance Connection Params
        [Parameter (Mandatory= $true)]
        [string] $instanceName,
        [Parameter (Mandatory= $true)]
        [string] $instanceKey,
        [Parameter (Mandatory= $true)]
        [string] $instanceZone,

        # API Params
        [Parameter (Mandatory= $true)]
        [string] $requestReference, 
        [Parameter (Mandatory= $true)]
        [string] $resolutionText, 
        [string] $updateVisibility = "trustedGuest", 
        [string] $closureCategoryId, 
        [string] $closureCategoryName
    )

    # Define instance details
    Set-HB-Instance -Instance $instanceName -Key $instanceKey -Zone $instanceZone

    # Build timeline update JSON
    $timelineUpdate = '{"requestId":"'+$requestReference+'",'
    if($closureCategoryName -eq $Null -or $closureCategoryName -eq ''){
        $timelineUpdate += '"updateText":"Request has been resolved:\n\n'+ $resolutionText+'",'
    } else {
        $timelineUpdate += '"updateText":"Request has been resolved with the category: '+$closureCategoryName+'\n\n'+ $resolutionText+'",'
    }
    $timelineUpdate += '"activityType":"Resolve",'
    $timelineUpdate += '"source":"webclient",'
    $timelineUpdate += '"postType":"Resolve",'
    $timelineUpdate += '"visiblity":"'+$updateVisibility+'"}'

    # Add XMLMC params
    Add-HB-Param "requestId" $requestReference $false
    Add-HB-Param "resolutionText" $resolutionText $false
    Add-HB-Param "closureCategoryId" $closureCategoryId $false
    Add-HB-Param "closureCategoryName" $closureCategoryName $false
    Add-HB-Param "updateTimelineInputs" $timelineUpdate $false

    # Invoke XMLMC call, output returned as PSObject
    $xmlmcOutput = Invoke-HB-XMLMC "apps/com.hornbill.servicemanager/Requests" "resolveRequest"

    $exceptionName = ""
    $exceptionSummary = ""
    # Read output status
    if($xmlmcOutput.status -eq "ok") {
        if($xmlmcOutput.params.activityId -and $xmlmcOutput.params.activityId -ne ""){
            $activityId = $xmlmcOutput.params.activityId
        }
        if($xmlmcOutput.params.exceptionName -and $xmlmcOutput.params.exceptionName -ne ""){
            $exceptionName = $xmlmcOutput.params.exceptionName
            $exceptionSummary = $xmlmcOutput.params.exceptionDescription
        }
    }
    # Build resultObject to write to output 
    $resultObject = New-Object PSObject -Property @{
        Status = $xmlmcOutput.status
        Error = $xmlmcOutput.error
        ActivityId = $activityId
        ExceptionName = $exceptionName
        ExceptionSummary = $exceptionSummary
    }
    
    if($resultObject.Status -ne "ok"){
        Write-Error $resultObject
    } else {
        if($resultOutput.ExceptionName -ne ""){
            Write-Warning $resultObject
        } else {
            Write-Output $resultObject
        }
    }
}