Get-Location
#Import DataBase
$Timer = Get-Date -Format "HH:mm"
$return = .'.\src\Modules\Set-up DataBase.ps1' -jsonFilePath .\Fase\Main.json

# $return moet 
#Ouput: ->Debug(Debug)  -> software| voor set-up Tekst -> install allen voor install