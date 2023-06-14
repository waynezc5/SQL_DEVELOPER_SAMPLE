<#
.SYNOPSIS
    This script will import all CSV files from a folder into a SQL Server database table.
.EXAMPLE
    .\load_csv_to_SQLServer.ps1
.NOTES
    This is the load phase of the ETL process.
    The CSV files will be loaded into the SQL Server database table using the column names from the database table created earlier from the DDL T-SQL script. 
    This script utilizes the dbatools module and the Import-DbaCsv cmdlet because it takes advantage of .NET's fast SqlBulkCopy class to import the data.
#>

Import-Module dbatools

# Set the SQL Server instance name
$SQLServer = "Lab-SQL19"

# Set the SQL Server database name
$Database = "SQL_DEVELOPER_SAMPLE"

# Set the path to the folder where the CSV files are located
$CSVFolder = "X:\CSV\"

$sa = Get-Credential -UserName sa

# Validate CSV folder existence
if (-not (Test-Path $CSVFolder)) {
    Write-Host "CSV folder does not exist: $CSVFolder"
    exit
}

#Loop through each CSV file and import the data into the SQL Server table using the column names from the database table
Get-ChildItem -Path $CSVFolder -Filter *.csv | ForEach-Object {
    $TableName = $_.BaseName
    $CSVFile = $_.FullName
    $Columns = (Get-DbaDbTable -SqlInstance $SQLServer -Database $Database -Table $TableName -SqlCredential $sa).Column
    
    Write-Output "Importing $CSVFile to $SQLServer.$Database.$TableName"
   
    try{
        #Import CSV data into SQL Server table
        Import-DbaCsv -SqlInstance $SQLServer -Database $Database -SqlCredential $sa -Table $TableName -Path $CSVFile -Delimiter "," -ColumnMap $Columns -KeepNulls
        Write-Output "Import completed successfully."
    }
    catch{
        Write-Output "Error occurred while importing $CSVFile to $SQLServer.$Database.$TableName"
    }
    
}
