<#
.SYNOPSIS
    Transform the CSV files to prepare for loading to SQL Server.
.EXAMPLE
    .\transform_csv_files.ps1
.NOTES
    This is the transformation phase of the ETL process.
    When inspecting the data, it was discovered that the TOT_ACCT_BAL and TOT_ENC_BAL columns had "-" values. These values were replaced with 0 to allow the datatype to be converted to a numeric type in SQL Server.
    The PRIM_ENC_NUMBER from the Account_Number column also had "#N/A" values. These values were replaced with an empty string to allow numeric data types in SQL Server and create foreign key constraints.
#>

$CSVFolder = "D:\Projects\SQL Developer BMC\CSV\"

# Trim each individual header column and save each CSV file in the folder
Get-ChildItem -Path $CSVFolder -Filter *.csv | ForEach-Object {
    $CSVFile = $_.FullName
    $CSVContent = Get-Content $CSVFile
    $headerRow = $CSVContent[0].Trim().Split(",")
    $trimmedHeaderRow = $headerRow | ForEach-Object { $_.Trim() }
    $CSVContent[0] = $trimmedHeaderRow -join ","
    $CSVContent | Set-Content $CSVFile
}

# Define a function to replace a value in a specific column
function ReplaceColumnValue($file, $columnIndex, $oldValue, $newValue) {
    $content = Get-Content $file
    for ($i = 1; $i -lt $content.Count; $i++) {
        $row = $content[$i]
        $columns = $row.Split(",")
        $value = $columns[$columnIndex].Trim()
        if ($value -eq $oldValue) {
            $columns[$columnIndex] = $newValue
        }
        $content[$i] = ($columns -join ",").Trim()
    }
    $content | Set-Content $file
}

# Replace "-" with 0 in the TOT_ACCT_BAL column of Account_Number.csv
$AccountNumberCSV = $CSVFolder + "Account_Number.csv"
ReplaceColumnValue $AccountNumberCSV 12 "-" 0
ReplaceColumnValue $AccountNumberCSV 13 "-" 0

# Replace "#N/A" with an empty string in the specified column of Account_Number.csv
ReplaceColumnValue $AccountNumberCSV 2 "#N/A" ""

# Replace "-" with 0 in the TOT_ENC_BAL column of Encounter_Number.csv
$EncounterNumberCSV = $CSVFolder + "Encounter_Number.csv"
ReplaceColumnValue $EncounterNumberCSV 5 "-" 0
