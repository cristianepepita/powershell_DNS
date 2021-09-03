# Descrição: Exportação dados DNS
# Data: Outubro 2018
# Autor: Cristiane Pepita

[CmdletBinding()]
param()

Import-Module DnsServer
$day = Get-Date
$Zonas = Get-DnsServerZone | Where-Object IsAutoCreated -ne "True" | Where-Object ZoneType -NE "Forwarder" | Where-Object ZoneName -NE "TrustAnchors" |Select-Object -ExpandProperty ZoneName
$DestBkp = "\\caminho"
$DNSLocal = "C:\Windows\System32\dns\"

[String]$DiaDaSemana = $day.DayOfWeek

Switch ($DiaDaSemana){
    Monday {$DiaDaSemana = "Segunda"}
    Tuesday {$DiaDaSemana = "Terca"}
    Wednesday {$DiaDaSemana = "Quarta"}
    Thursday {$DiaDaSemana = "Quinta"}
    Friday {$DiaDaSemana = "Sexta"}
}

[String]$DiaDaSemanaCurto = $DiaDaSemana.Substring(0,3).ToLower()

foreach($Zona in $Zonas){
    If (!(Test-Path -Path $DestBkp$DiaDaSemana)){
        New-Item -ItemType Directory -Path $DestBkp -Name $DiaDaSemana
    }

    If (Test-Path -Path $DnsLocal"DNS-$Zona-$DiaDaSemanaCurto.txt"){
        Remove-Item $DnsLocal"DNS-$Zona-$DiaDaSemanaCurto.txt"
    }
    Export-DnsServerZone -Name $Zona -FileName "DNS-$Zona-$DiaDaSemanaCurto.txt"
    Copy-Item $DnsLocal"DNS-$Zona-$DiaDaSemanaCurto.txt" -Destination $DestBkp$DiaDaSemana
}