# SQL_DEVELOPER_SAMPLE

## Workflow, Documentation, Thought Processes

Here's an overview of the workflow and thought processes followed during the project:
### 1.	Data Review:
Reviewed the data in the Excel file to understand its structure and contents.
### 2.	Relational Diagram:
Created a relational diagram, visualizing the worksheets as tables to better understand the data relationships.
Refer to the "SQL_SERVER_SAMPLE diagram design.jpeg" file for the diagram.
### 3.	Database Creation:
Developed T-SQL code to create the necessary database, tables, constraints, and indexes based on the relational diagram.
 Find the code in the ![create_database_tables.sql](https://github.com/waynezc5/SQL_DEVELOPER_SAMPLE/blob/main/create_database_tables.sql) file.
### 4.	ETL Processing:
Identified the need for ETL processing to load the data into SQL Server.
Utilized PowerShell scripts for this purpose, although Python or SSIS could also be viable options. ![extract_sheets_to_csv.ps1](https://github.com/waynezc5/SQL_DEVELOPER_SAMPLE/blob/mai/extract_sheets_to_csv.ps1) extracts each sheet from the Excel file and saves them as individual .csv files (not included in the repository). ![transform_csv_files.ps1](https://github.com/waynezc5/SQL_DEVELOPER_SAMPLE/blob/main/transform_csv_files.ps1) performs necessary transformations on the .csv files, such as trimming column headers and removing unwanted characters. ![load_csv_to_SQLServer.ps1](https://github.com/waynezc5/SQL_DEVELOPER_SAMPLE/blob/main/load_csv_to_SQLServer.ps1) uses .NET's bulkloadcopy to efficiently load the transformed .csv files into SQL Server. The process completes within 10-15 seconds.
### 5.	Questions:
The file ![Questions & Answers.ipynb](https://github.com/waynezc5/SQL_DEVELOPER_SAMPLE/blob/main/Questions%20%26%20Answers.ipynb) contains the SQL Server queries, notes and corresponding results for the provided questions. This file can be viewed on GitHub or downloaded as a Notebook in Azure Data Studio for further exploration. 

### 
The combined efforts of data review, diagramming, T-SQL development, ETL processing, and documentation allowed for comprehensive analysis and effective answering of the provided questions within a SQL Server environment.


