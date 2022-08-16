
$location="westeurope"
$resourceGroup="data_science"
$storage="ceodsstorage"
$eventhubNS="ceo-ds-eventhub-namespace"
$eventhubEH="ceo-ds-eventhub-1"
$sendFunctionAppName="ceo-ds-send-app"
$recFunctionAppName="ceo-ds-rec-app"


Login to azure 

az login
az account set --subscription dcfb8e69-724f-40a6-8580-7e8add073db9

Step 1: Create EventHub

Create eventHub name space

az eventhubs namespace create --name $eventhubNS --resource-group $resourceGroup -l $location

Create eventHub

az eventhubs eventhub create --name $eventhubEH --resource-group $resourceGroup --namespace-name $eventhubNS

Create eventHub auth rule

az eventhubs eventhub authorization-rule create --resource-group $resourceGroup --namespace-name $eventhubNS --eventhub-name $eventhubEH --name myauthorule --rights Listen, send

Get the primaryConnectionString from the eventHub auth rule

az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroup --namespace-name $eventhubNS --eventhub-name $eventhubEH --name myauthorule --query primaryConnectionString > ehconnection.txt

Save the primaryConnectionString to a text file

$ehconnection = Get-Content .\ehconnection.txt

Create eventHub consumer-group

az eventhubs eventhub consumer-group create --resource-group $resourceGroup --namespace-name $eventhubNS --eventhub-name $eventhubEH --name myconsumergroup

Step 2: Create send function app

Create the Function App files

func init $sendFunctionAppName –python

Create the Function files

cd $sendFunctionAppName
func new --name send-eventhub --template "Timer trigger" 

Update the __init__.py and function.json files

