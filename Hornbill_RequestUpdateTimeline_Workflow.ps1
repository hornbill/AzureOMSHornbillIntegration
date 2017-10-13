###
# Hornbill_RequestUpdateTimeline_Workflow
# Azure Powershell Runbook to update the timeline of a request within Service Manager on a Hornbill Instance
#
# Modules required to be installed on the Automation Account this runbook is called from:
# HornbillAPI
###

##############################
#.SYNOPSIS
#Azure Powershell Runbook to update the timeline of a request within Service Manager on a Hornbill Instance
#
#.DESCRIPTION
#Azure Powershell Runbook to update the timeline of a request within Service Manager on a Hornbill Instance
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
#.PARAMETER action
#An action name for the operation.
#
#.PARAMETER source
#Source (device type or logical) where the update was performed Example: webclient, email, mobile...
#
#.PARAMETER content
#MANDATORY: The update text itself. This is the main body of the post to the request timeline.
#
#.PARAMETER extra
#Extra details for the update. Is a well formatted JSON String.
#
#.PARAMETER visibility
#Visibility for the post - the default is trustedGuest.
#
#.PARAMETER imageUrl
#The url of an image to be posted as part of the update.
#
#.PARAMETER activityType
#The type of activity. When querying activities this can be used to filter activities.
#
#.NOTES
#Modules required to be installed on the Automation Account this runbook is called from:
# - HornbillAPI
###############################
workflow Hornbill_RequestUpdateTimeline_Workflow
{
    #Define Output Stream Type
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
        [string] $content, 
        [string] $action, 
        [string] $source, 
        [string] $extra, 
        [string] $visibility = "trustedGuest",
        [string] $imageUrl,
        [string] $activityType
    )

    # Define instance details
    Set-HB-Instance -Instance $instanceName -Key $instanceKey -Zone $instanceZone


    # Add XMLMC params
    Add-HB-Param "requestId" $requestReference $false
    Add-HB-Param "action" $action $false
    Add-HB-Param "source" $source $false
    Add-HB-Param "content" $content $false
    Add-HB-Param "extra" $extra $false
    Add-HB-Param "visibility" $visibility $false
    Add-HB-Param "imageUrl" $imageUrl $false
    Add-HB-Param "activityType" $activityType $false

    # Invoke XMLMC call, output returned as PSObject
    $xmlmcOutput = Invoke-HB-XMLMC "apps/com.hornbill.servicemanager/Requests" "updateReqTimeline"

    # Read output status
    if($xmlmcOutput.status -eq "ok") {
        if($xmlmcOutput.params.activityId -and $xmlmcOutput.params.activityId -ne ""){
            $activityId = $xmlmcOutput.params.activityId
            $outcome = $xmlmcOutput.params.outcome
        }
    }
    # Build resultObject to write to output 
    $resultObject = New-Object PSObject -Property @{
        Status = $xmlmcOutput.status
        Error = $xmlmcOutput.error
        ActivityId = $activityId
        Outcome = $outcome
    }
    
	if($resultObject.Status -ne "ok"){
        Write-Error $resultObject
    } else {
		Write-Output $resultObject
    }
}