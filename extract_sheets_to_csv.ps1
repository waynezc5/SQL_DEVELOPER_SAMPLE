<#
.SYNOPSIS
    Extract all sheets from the SAMPLE_DATA_SQL_DEVELOPER_06132023 file to CSV files. 
.EXAMPLE
    .\extract_sheets_to_csv.ps1
.NOTES
    This is the extraction phase of the ETL process.
    The CSV files will all be extracted from Excel and saved based on the sheet name and saved in the output folder. The script will exclude the sheet "Questions" and rename "Rev Code" sheet to "Rev_Code". 
    This is to make the bulk loading of the CSV files to SQL Server easier.

#>

# Path to Excel file
$ExcelFile = "D:\Projects\SQL Developer BMC\SAMPLE_DATA_SQL_DEVELOPER_06132023.xlsx"

# Path to output folder
$OutPutFolder = "D:\Projects\SQL Developer BMC\CSV\"

# Load Excel
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false
$Excel.DisplayAlerts = $false

try {
    # Open Excel file
    $Workbook = $Excel.Workbooks.Open($ExcelFile)

    # Loop through each sheet and export to CSV file
    foreach ($ws in $Workbook.Worksheets) {
        if ($ws.Name -ne "Questions") {
            # Exclude the sheet "Questions" and rename "Rev Code" sheet to "Rev_Code"
            $sheetName = $ws.Name
            if ($sheetName -eq "Rev Codes") {
                $sheetName = "Rev_Codes"
                $ws.Name = $sheetName
            }

            # Construct the output CSV file path
            $csvFile = Join-Path $OutPutFolder "$sheetName.csv"

            # Export the sheet to CSV
            $ws.SaveAs($csvFile, 6)
           
        }
    }
}
catch {
    # Error handling
    Write-Host $_.Exception.Message
}
finally {
    # Close workbook and quit Excel
    $Workbook.Close()
    $Excel.Quit()

}


