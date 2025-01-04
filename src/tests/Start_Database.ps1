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
                            $_
                            #Invoke-Expression
                        }
                    }
                }
            }
        }
    }
}