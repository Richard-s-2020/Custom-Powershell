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

        $jsonContent.PSObject.Properties | ForEach-Object {
            $_.value.PSObject.Properties | ForEach-Object {
                if ($_.Name -eq "Categories") {
                    $Categories = $_.Value
                }
                elseif ($_.Name -eq "text") {
                    $_.Value.PSObject.Properties | ForEach-Object {
                        $Temp_text = $_.name       
                        $_.value.PSObject.Properties | ForEach-Object {
                            if ($_.Name -eq "Title"){

                            }
                        }
                        Pause
                    }
                }
            }
        }
    }
}