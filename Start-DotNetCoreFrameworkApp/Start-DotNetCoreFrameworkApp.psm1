
<#
.Synopsis
   Starts .NET Core Framework app if not running
.DESCRIPTION
   This script is intended to be used alongside Windows 
   Task Scheduler to ensure that the specified .NET CORE
   Framework application is always running.
   
   This script once excute checks the processes for the 
   named Framework app and will start it if not discovered
   otherwise the script will terminate.
.EXAMPLE
   Start-DotNetCoreFrameworkApp -DLL "testsite.dll" -Location "c:\scripts\"
#>
function Start-DotNetCoreFrameworkApp
{
    Param
    (
        # Framework DLL filename        
        [Parameter(Mandatory)]
        [string]
        $DLL,

        # Directory location of Framework
        [Parameter(Mandatory)]
        [string]
        $Location
    )
       
    Process
    {        
        # Find dotnet CORE framework app processes
        $result = Get-CimInstance Win32_Process -Filter "name = 'dotnet.exe'" | select CommandLine
        
        # Find if any match our dll
        $match = ($result -match $DLL)
        Write-Output "Process Match: $match"

        if ($match)
        {
            # Found. No need to start process
            Write-Output "dotnet.exe $DLL found"
        }
        else
        {    
            #Process is not running. Start new process
            Write-Output "dotnet.exe $DLL not started."
            Write-Output "Starting..."
            Set-Location -Path $Location
            dotnet.exe $DLL
        }
    }  
}