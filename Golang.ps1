<#
.SYNOPSIS
Install software on development system.

.DESCRIPTION
Install software on development system.

.PARAMETER AutoUpgrade
Automatically upgrade packages installed with Chocolatey to their latest versions.
#>
Configuration GolangDevelopmentMachine
{
    Param (
        [switch]$AutoUpgrade
    )

    Import-DscResource -ModuleName cChoco -ModuleVersion 2.4.0.0
    Import-DscResource -ModuleName PackageManagement -ModuleVersion 1.2.4
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node "localhost"
    {
        # Chocolatey packages
        cChocoinstaller Install {
            InstallDir = "C:\ProgramData\chocolatey"
        }
        cChocoPackageInstaller installGolang
        {
            Name                 = 'golang'
            Ensure               = 'Present'
            AutoUpgrade          = $AutoUpgrade
            Version              = 1.12.1
            DependsOn            = '[cChocoInstaller]Install'
        }

   }
}

GolangDevelopmentMachine
Start-DscConfiguration -Path .\GolangDevelopmentMachine -Wait -Verbose -Force
