param (
    [string]$jsonFilePath = ".\DataBase\main.json"
)

if (Test-Path $jsonFilePath) {
    # Read the JSON file
    $jsonContent = Get-Content $jsonFilePath -Raw | ConvertFrom-Json
    $Return = [PSCustomObject]@{}
    $air = [PSCustomObject]@{}

    # Output the Load_Module and DataBase sections
    $jsonContent.PSObject.Properties | ForEach-Object {
        if ($_.Name -match "Load_Module") {
            $temp = $_.Value
            $Main_Return = ""
            $Temp_Return = ""
            $temp.PSObject.Properties | ForEach-Object {
                if ($_.name -eq ".Return_command") {
                    $Main_Return = $_.Value
                    $Return | Add-Member -MemberType NoteProperty -Name $Main_Return -Value $air
                }
                else {
                    $Value_Set = ""
                    $_.Value.PSObject.Properties | Sort-Object | ForEach-Object {
                        if ($_.Name -eq ".Return_command") {
                            $Temp_Return = $_.Value
                        }
                        if ($_.Name -eq "Check") {
                            if ($_.Value -match "True") {
                                $Value_Set = $_.Value
                            }
                            elseif ($_.Value -match "False") {
                                $Value_Set = $_.Value
                            }
                        }
                        else {
                            if ($Value_Set -eq "true") {
                                if (!(Test-Path $_.Value)) {
                                    New-Item $_.Value -ItemType Directory
                                }
                                $temp = $_.Value
                                $Return.$Main_Return | add-Member -MemberType NoteProperty -Name $Temp_Return -Value $temp

                                $script = Get-ChildItem $_.Value -Filter "*.ps1"
                                if (!($script -match "Set-up DataBase")) {
                                    Import-Module $script
                                }
                            }
                        }
                    }
                }
            }
        }
        elseif ($_.Name -match "DataBase") {
            $temp = $_.Value
            $Main_Return = ""
            $temp.PSObject.Properties | ForEach-Object {
                if ($_.name -eq "Default") {
                    $Path = ".\" + $_.Value + "\"
                }elseif($_.name -eq ".Return_command"){
                    $Main_Return = $_Value
                    Pause
                }
                else {
                    $_.Value.PSObject.Properties | ForEach-Object {
                        $_ | Sort-Object | ForEach-Object {
                            $_.Value.PSObject.Properties | Sort-Object | ForEach-Object {
                                if ($_.Name -eq "Folder") {
                                    $Full_Path = $Path + $_.Value + "\"
                                    if (!(Test-Path $Full_Path)) {
                                        New-Item $Full_Path -ItemType Directory
                                    }
                                }
                                elseif ($_.Name -eq "Item") {
                                    if ($_.Value -match ",") {
                                        $_.Value -split "," | ForEach-Object {
                                            $Temp = $Full_Path + $_
                                            if (!(Test-Path $Temp)) {
                                                New-Item $Temp
                                            }
                                        }
                                    }
                                    else {
                                        $Temp = $Full_Path + $_.Value
                                        if (!(Test-Path $Temp)) {
                                            New-Item $Temp
                                        }
                                    }
                                    
                                }else {
                                    $_
                                    Pause
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            $Path = ""
            $temp = ""
            $_.Value.PSObject.Properties | Sort-Object | ForEach-Object {
                if ($_.name -eq "Folder") {
                    $Path = ".\" + $_.Value + "\"
                    if (!(Test-Path $Path)) {
                        New-Item $Path -ItemType Directory
                    }
                }
                elseif ($_.name -eq "Item") {
                    $Path = $Path + $_.Value
                    if (!(Test-Path $Path)) {
                        New-Item $Path
                    }
                    $Return | Add-Member -MemberType NoteProperty -Name $temp -Value $Path
                }else {
                    $temp = $_.Value
                }
            }
        }
    }
}
else {
    Write-Error "Teh Database is air"
}