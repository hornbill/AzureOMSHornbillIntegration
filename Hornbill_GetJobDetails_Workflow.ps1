##############################
#.SYNOPSIS
#Powershell Runbook to get the details of a Job running in Azure
#
#.DESCRIPTION
#Azure Powershell Runbook to retrieve the details of a Job running in Azure
#
#.PARAMETER connectionName
#MANDATORY: The name of the Azure Connection to run the request as
#
#.PARAMETER jobId
#MANDATORY: The ID of the Job to retrieve
#
#.NOTES
###############################
workflow Hornbill_GetJobDetails_Workflow
{
    # Define output stream type
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
        [string] $contactId
    )

    # Define instance details
    Set-HB-Instance -Instance $instanceName -Key $instanceKey -Zone $instanceZone

    # Build XMLMC call
    Add-HB-Param "h_pk_id" $contactId $false

    # Invoke XMLMC call, output returned as PSObject
    $xmlmcOutput = Invoke-HB-XMLMC "apps/com.hornbill.core/Contact" "archiveContact"

    # Build resultObject to write to output 
    $resultObject = New-Object PSObject -Property @{
        Status = $xmlmcOutput.status
        Error = $xmlmcOutput.error
    }
    
    if($resultObject.Status -ne "ok"){
        Write-Error $resultObject
    } else {
        Write-Output $resultObject
    }
}