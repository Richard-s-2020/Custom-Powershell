param (
    [string]$jsonFilePath = ".\Software\main.json",
    [string]$softwarePath = ".\Fase\Software"
)

if (!(($jsonFilePath -eq "") -or ($null -eq $jsonFilePath))) {
    if (Test-Path $jsonFilePath) {
        $jsonContent = Get-Content $jsonFilePath -Raw | ConvertFrom-Json
        $Text = [PSCustomObject]@{}
        $Color = [PSCustomObject]@{}
        $install = [PSCustomObject]@{}
        $air = [PSCustomObject]@{}

        $jsonContent.PSObject.Properties | ForEach-Object {
            $_.value.PSObject.Properties | ForEach-Object {
                if ($_.Name -eq "Categories") {
                    $Categories = $_.Value
                    $Text | Add-Member -MemberType NoteProperty -Name $Categories -Value $air
                    $air = [PSCustomObject]@{}
                    $Color | Add-Member -MemberType NoteProperty -Name $Categories -Value $air
                    $air = [PSCustomObject]@{}
                    $install | Add-Member -MemberType NoteProperty -Name $Categories -Value $air
                }
                elseif ($_.Name -eq "text") {
                    $_.Value.PSObject.Properties | ForEach-Object {
                        $Temp_text = $_.name      
                        $_.value.PSObject.Properties | ForEach-Object {
                            
                            if ($_.Name -eq "Title") {
                                $temp_Name = $_.value
                                $Text.$Categories | Add-Member -MemberType NoteProperty -Name $Temp_text -Value $temp_Name
                            }
                            else {
                                $Temp_Color = $_.value
                                $Color.$Categories | Add-Member -MemberType NoteProperty -Name $Temp_text -Value $Temp_Color
                            }
                        }
                    }
                }
                else {
                    $_.Value.PSObject.Properties | Sort-Object | ForEach-Object {
                        $_.value.PSObject.Properties | ForEach-Object {
                            if ($_.name -eq "Module") {
                                switch ($_.Value) {
                                    "path" { $Module = "Test-Path" }
                                }
                            }
                            elseif ($_.name -eq "Path") {
                                if ($_.value -match "HKEY") {
                                    switch -Wildcard ($_.Value) {
                                        "*CLASSES_ROOT*" { $_ -replace "HKEY_CLASSES_ROOT","HKCR:"}
                                        "*CURRENT_USER*" { $_ -replace "HKEY_CURRENT_USER","HKCU:"}
                                        "*LOCAL_MACHINE*" { $_ -replace "HKEY_LOCAL_MACHINE","HKLM:"}
                                        "*HKEY_USERS*" { $_ -replace "HKEY_HKEY_USERSE","HKU:"}
                                        "*CURRENT_CONFIG*" { $_ -replace "HKEY_CURRENT_CONFIG","HKCC:"}
                                    }
                                } 
                            }
                            else {}
                            #Invoke-Expression
                        }
                    }
                }
            }
        }
    }
}