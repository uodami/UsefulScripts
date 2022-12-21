$storageName = $args[0]
$connectionString = "AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;DefaultEndpointsProtocol=http;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;TableEndpoint=http://127.0.0.1:10002/devstoreaccount1;"

if($storageName -eq $null)
{
    throw "The storage name parameter cannot be null."
}

#az login

Write-Host "Starting the deletion of blob storages, queue storages and table storages which names contain $storageName"

$tablesNames = az storage table list --connection-string $connectionString | ConvertFrom-Json
$filteredTablesNames = $tablesNames.Where({$_.name -like "*$storageName*"})

foreach($tableName in $filteredTablesNames)
{
    Write-Host "Deleting table storage $($tableName.name) ..."
    az storage table delete --name $tableName.name --connection-string $connectionString
}

$queuesNames = az storage queue list --connection-string $connectionString | ConvertFrom-Json
$filteredQueuesNames = $queuesNames.Where({$_.name -like "*$storageName*"})

foreach($queueName in $filteredQueuesNames)
{
    Write-Host "Deleting queue $($queueName.name) ..."
    az storage queue delete --name $queueName.name --connection-string $connectionString
}

$containersNames = az storage container list --connection-string $connectionString | ConvertFrom-Json
$filteredContainersNames = $containersNames.Where({$_.name -like "*$storageName*"})

foreach($containerName in $filteredContainersNames)
{
    Write-Host "Deleting container $($containerName.name) ..."
    az storage container delete --name $containerName.name --connection-string $connectionString
}