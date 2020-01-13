
<#
.Synopsis
   Stops .NET Core Framework app
.DESCRIPTION
   This script is to shutdown a .NET Core Framework App using the dll name
.EXAMPLE
   Stop-DotNetCoreFrameworkApp -DLL "testsite.dll"
#>
function Stop-DotNetCoreFrameworkApp
{
    Param
    (
        # Framework DLL filename        
        [Parameter(Mandatory)]
        [string]
        $DLL
    )
       
    Process
    {        
        $Result = Get-CimInstance Win32_Process -Filter "name = 'dotnet.exe'" `
        | Where-Object {$_.CommandLine -like "*$DLL"}         

		$ProcessId = $Result.ProcessId 
   
        if ($Result -ne $null)
        {
            # Found. Stop process
            Write-Output "dotnet.exe $DLL found [$ProcessId]"

            #stackoverflow.com/questions/28481811/how-to-correctly-check-if-a-process-is-running-and-stop-it
            $Process = Get-Process -Id $ProcessId 
            
            if ($Process) {
              # try gracefully first            
              $Process.CloseMainWindow()
              # kill after five seconds            
              Sleep 5
              if (!$Process.HasExited) {            
                $Process | Stop-Process -Force
              }
            }
            Remove-Variable Process
        }
        else
        {    
            #Process is not running. 
            Write-Output "dotnet.exe $DLL not found." 
        }
    }  
}