
# Can import dbatools
Describe "Module is good to go" {
    Context "dbatools imports" {
        #$null = Import-Module dbatools
        $module = Get-Module dbatools
        It "Module was imported" {
            $module | Should Not BeNullOrEmpty
        }
        It "Module version is 1.1.95" {
            $module.Version | Should Be "1.1.95"
        }
        It "Module should import 528 commands" {
            (get-command -module dbatools -CommandType Function | Measure).Count | Should Be 528
        }
    }
}

# credential exists
Describe "Credentials exist" {
    Context "Credential exists" {
        It "Credential is not null" {
            $containerCredential | Should Not BeNullOrEmpty
        }
    }
    Context "username is sqladmin" {
        It "Username is sqladmin" {
            $containerCredential.UserName | Should Be "sqladmin"
        }
    }
    Context "PSDefaultParameterValues are set" {
        $params = $PSDefaultParameterValues
        It "PSDefaultParameterValues contains expected values" {
            $params.Keys -contains '*dba*:SqlCredential' | Should Be True
            $params.Keys -contains '*dba*:SourceSqlCredential' | Should Be True
            $params.Keys -contains '*dba*:DestinationCredential' | Should Be True
            $params.Keys -contains '*dba*:DestinationSqlCredential' | Should Be True
        }
    }
}
# two instances
Describe "Two instances are available" {
    Context "Two instances are up" {
        $dbatools1 = Connect-DbaInstance -SqlInstance $dbatools1
        $dbatools2 = Connect-DbaInstance -SqlInstance $dbatools2
        It "dbatools1 is available" {
            $dbatools1.Name | Should Not BeNullOrEmpty
            $dbatools1.Name | Should Be 'dbatools1'
        }
        It "dbatools2 is available" {
            $dbatools2.Name | Should Not BeNullOrEmpty
            $dbatools2.Name | Should Be 'dbatools2'
        }
    }
}
# dbatools1 has 2 databases
Describe "dbatools1 databases are good" {
    Context "AdventureWorks2017 is good" {
        $db = Get-DbaDatabase -SqlInstance $dbatools1
        $adventureWorks = $db | where name -eq 'AdventureWorks2017'
        It "AdventureWorks2017 is available" {
            $adventureWorks | Should Not BeNullOrEmpty
        }
        It "AdventureWorks status is normal" {
            $adventureWorks.Status | Should Be Normal
        }
        It "AdventureWorks Compat is 140" {
            $adventureWorks.Compatibility | Should Be 140
        }
    }
    Context "Indexes are fixed on HumanResources.Employee (bug)" {
        $empIndexes = (Get-DbaDbTable -SqlInstance $dbatools1 -Database AdventureWorks2017 -Table Employee).indexes | select name, IsUnique
        It "There are now just two indexes" {
            $empIndexes.Count | Should Be 2
        }
    }
    Context "DatabaseAdmin is good" {
        $db = Get-DbaDatabase -SqlInstance $dbatools1
        $DatabaseAdmin = $db | where name -eq 'DatabaseAdmin'
        It "DatabaseAdmin is available" {
            $DatabaseAdmin | Should Not BeNullOrEmpty
        }
        It "DatabaseAdmin status is normal" {
            $DatabaseAdmin.Status | Should Be Normal
        }
        It "DatabaseAdmin Compat is 140" {
            $DatabaseAdmin.Compatibility | Should Be 140
        }
    }
}

Describe "Backups worked" {
    Context "AdventureWorks was backed up" {
        $instanceSplat = @{
            SqlInstance = $dbatools1
        }
        It "AdventureWorks has backup history" {
            Get-DbaDbBackupHistory @instanceSplat | Should Not BeNullOrEmpty
        }
    }
}

Describe "Proc architecture is x64" {
    Context "Proc arch is good" {
        It "env:processor_architecture should be AMD64" -skip {
            $env:PROCESSOR_ARCHITECTURE | Should Be "AMD64"
        }
    }
}

Describe "Check what's running" {
    $processes = Get-Process zoomit*, teams, slack -ErrorAction SilentlyContinue
    Context "Check tools running" {
        It "ZoomIt64 is running" -skip {
            ($processes | Where-Object ProcessName -eq 'Zoomit64') | Should Not BeNullOrEmpty
        }
        It "Slack is not running" -skip {
            ($processes | Where-Object ProcessName -eq 'Slack') | Should BeNullOrEmpty
        }
        It "Teams is not running" -skip {
            ($processes | Where-Object ProcessName -eq 'Teams') | Should BeNullOrEmpty
        }
    }
}