# This project has been retired, and replaced by https://github.com/hornbill/powershellHornbillAzureRunbooks

# Azure and OMS Hornbill Integration

A collection of Powershell Runbooks and Modules for Microsoft Azure Automation and Operations Management Suite, to demonstrate integration with the Hornbill Collaboration platform and Service Manager application.

Please see the description within each Runbook and/or Module for more information about functionality, input parameters, and the APIs that they use.

## Modules

IMPORTANT! Both of the supplied modules (HornbillAPI and HornbillHelpers) are required to be added to the Azure Automation account prior to making use of the Hornbill Runbooks. See the .psm1 Module files within the Module ZIPs for more information on the input and output parameters for each CMDLET.

__HornbillAPI.zip__ : This module contains the required CMDLETs to build and fire API calls from Azure Runbooks to your Hornbill instance:

- _Set-HB-Instance_ : MANDATORY - Allows your Powershell script to define the Hornbill instance to connect to, the zone in which it resides, and the API key to use for session generation.
- _Add-HB-Param_ : Add a parameter to the XMLMC request
- _Clear-HB-Params_ : Clears any existing XMLMC parameters that have been added
- _Open-HB-Element_ : Allows for the building of complex XML
- _Close-HB-Element_ : Allows for the building of complex XML
- _Invoke-HB-XMLMC_ : Invokes your API call
- _ConvertTo-HB-B64Decode_ : Returns a UTF8 string from a given Base64 endcoded string
- _ConvertTo-HB-B64Encode_ : Returns a Base64 encoded string from a given UTF8 string
- _Get-HB-Params_ : Returns XML string of parameters that have been added by Add-HB-Params, Open-HB-Element and Close-HB-Element

__HornbillHelpers.zip__ : This module contains a number of helper CMDLETs to carry out common requests within Hornbill Runbooks:

- _Get-HB-CatalogID_ : Provide a Catalog Item Name, and this CMDLET will search your Hornbill instance for a matching record, returning the Primary Key
- _Get-HB-OrganisationID_ : Provide a Organisation Name, and this CMDLET will search your Hornbill instance for a matching record, returning the Primary Key
- _Get-HB-PriorityID_ : Provide a Priority Name, and this CMDLET will search your Hornbill instance for a matching record, returning the Primary Key
- _Get-HB-Request_ : Retrieves details about a Request
- _Get-HB-ServiceID_ : Provide a Service Name, and this CMDLET will search your Hornbill instance for a matching record, returning the Primary Key
- _Get-HB-SiteID_ : Provide a Site Name, and this CMDLET will search your Hornbill instance for a matching record, returning the Primary Key
- _Get-HB-WorkspaceID_ : Provide a Workspace Name, and this CMDLET will search your Hornbill instance for a matching record, returning the Activity Stream ID

To add a module to your Azure Automation Account:

- Open Microsoft Azure in your browser and navigate to your Automation Account
- Click on `Modules` under `Shared Resources`
- Click the `Add a module` button
- Use the `Upload File` control to find and select your Module, then click the `OK` button
- On the list of Modules, wait for the Module Status to become `Available` before attempting to run any Runbooks that use them.

## Runbooks

We're provided a number of example Powershell Runbooks to allow your Azure Automation Account (and therefore the Microsoft Operations Management Suite) to interact with your Hornbill instance. Please see the Runbooks themselves for more detailed information regarding input parameters etc:

- _Hornbill_ContactArchive_Workflow_ : Archives a Contact
- _Hornbill_ContactCreate_Workflow_ : Creates a Contact
- _Hornbill_RequestClose_Workflow_ : Closes a Service Manager Request
- _Hornbill_RequestLogChangeRequest_Webhook_ : Logs a Change Request within Service Manager - this should be called with an Azure Webhook, and is useful when setting up Alerts in Operations Management Suite
- _Hornbill_RequestLogChangeRequest_Workflow_ : Logs a Change Request within Service Manager - this is a Powershell Workflow, and can be called from other Azure Workflow Runbooks (Powershell or Graphical)
- _Hornbill_RequestLogIncident_Webhook_ : Logs an Incident within Service Manager - this should be called with an Azure Webhook, and is useful when setting up Alerts in Operations Management Suite
- _Hornbill_RequestLogIncident_Workflow_ : Logs an Incident within Service Manager - this is a Powershell Workflow, and can be called from other Azure Workflow Runbooks (Powershell or Graphical)
- _Hornbill_RequestLogServiceRequest_Webhook_ : Logs a Service Request within Service Manager - this should be called with an Azure Webhook, and is useful when setting up Alerts in Operations Management Suite
- _Hornbill_RequestLogServiceRequest_Workflow_ : Logs a Service Request within Service Manager - this is a Powershell Workflow, and can be called from other Azure Workflow Runbooks (Powershell or Graphical)
- _Hornbill_RequestResolve_Workflow_ : Resolved a Service Manager Request
- _Hornbill_RequestUpdateDetails_Workflow_ : Updates the details of a Service Manager Request
- _Hornbill_RequestUpdateTimeline_Workflow_ : Updates the timeline of a Service Manager Request
- _Hornbill_UserAddGroup_Workflow_ : Adds a Hornbill User to a Hornbill Group
- _Hornbill_UserAddRoles_Workflow_ : Adds one or more Roles to a Hornbill User
- _Hornbill_UserAddWorkspace_Workflow_ : Adds a Hornbill User to a Hornbill Collaboration Workspace
- _Hornbill_UserArchive_Workflow_ : Archives a Hornbill User account
- _Hornbill_UserCreate_Workflow_ : Creates a Hornbill User account
- _Hornbill_UserDelete_Workflow_ : Deletes a Hornbill User account
- _Hornbill_WorkspaceCreate_Workflow_ : Creates a Hornbill Collaboration Workspace
- _Hornbill_WorkspacePost_Webhook_ : Adds a Post to a Hornbill Collaboration Workspace - this should be called with an Azure Webhook, and is useful when setting up Alerts in Operations Management Suite
- _Hornbill_WorkspacePost_Workflow_ : Adds a Post to a Hornbill Collaboration Workspace - this is a Powershell Workflow, and can be called from other Azure Workflow Runbooks (Powershell or Graphical)
- _Hornbill_WorkspacePostComment_Workflow_ : Adds a Comment to an existing Post on a Hornbill Collaboration Workspace

To add a Runbook to your Azure Automation Account:

- Open Microsoft Azure in your browser and navigate to your Automation Account
- Click on `Runbooks` under `Process Automation`
- Click the `Add a runbook` button
- Click `Import an existing runbook`
- Use the `Runbook File` control to find and select your Runbook, then click the `OK` button
- Give the Runbook a description should you so wish, then click the `Create` button to add the Runbook to your Runbook library
