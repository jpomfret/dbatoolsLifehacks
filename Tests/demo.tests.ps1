
# Can import dbatools
Describe "Module is good to go" {
    Context "dbatools imports" {
        #$null = Import-Module dbatools
        $module = Get-Module dbatools
        It "Module was imported" {
            $module | Should Not BeNullOrEmpty
        }
        It "Module version is 2.1.28" {
            $module.Version | Should Be "2.1.28"
        }
        It "Module should import 694 commands" {
            (get-command -module dbatools -CommandType Function | Measure).Count | Should Be 694
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
        $dbatools1 = Connect-DbaInstance -SqlInstance "dbatools1"
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
    BeforeAll {
        $db = Get-DbaDatabase -SqlInstance "dbatools1"
    }
    Context "Northwind is good" {
        $Northwind = $db | Where-Object name -eq 'Northwind'
        It "Northwind is available" {
            $Northwind | Should Not BeNullOrEmpty
        }
        It "Northwind status is normal" {
            $Northwind.Status | Should Be Normal
        }
        It "Northwind Compat is 140" {
            $Northwind.Compatibility | Should Be 130
        }
    }
    Context "DatabaseAdmin is good" {
        $DatabaseAdmin = $db | where name -eq 'DatabaseAdmin'
        It "DatabaseAdmin is available" {
            $DatabaseAdmin | Should Not BeNullOrEmpty
        }
        It "DatabaseAdmin status is normal" {
            $DatabaseAdmin.Status | Should Be Normal
        }
        It "DatabaseAdmin Compat is 140" {
            $DatabaseAdmin.Compatibility | Should Be 150
        }
    }
}

Describe "dbatools2 shouldn't have any databases" {
    BeforeAll {
        $db = Get-DbaDatabase -SqlInstance $dbatools2 -ExcludeSystem
    }
    Context "There should be no databases" {
        It "Get-DbaDatabase should return nothing" {
            $db | Should BeNullOrEmpty
        }
    }
}

Describe "Backups worked" {
    Context "Northwind was backed up" {
        $instanceSplat = @{
            SqlInstance = "dbatools1"
            Database = 'Northwind'
        }
        It "Northwind has backup history" {
            Get-DbaDbBackupHistory @instanceSplat | Should Not BeNullOrEmpty
        }
    }
}