$Databases = @("cve", "exploitdb", "openvas", "osvdb", "scipvuldb", "securityfocus", "securitytracker", "xforce")

foreach ($DB in $Databases) {
    Invoke-WebRequest -Uri "https://www.computec.ch/projekte/vulscan/download/$DB.csv" -OutFile "$DB.csv"
    
    if (Test-Path "$DB.csv.1") {
        Rename-Item -Path "$DB.csv.1" -NewName "$DB.csv" -Force
    }
}
