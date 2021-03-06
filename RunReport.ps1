#Import credential
cd C:\
$password = Get-Content C:Office365cred.txt | ConvertTo-SecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList Sys.admin@demo.com.hk,$password
$s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -Authentication Basic -AllowRedirection
Connect-MsolService -Credential $cred 
$importresults = Import-PSSession $s

#Set Date
$date = Get-Date -Format "MM-dd-yyyy"

#Get Data
$adomainlist = Get-MsolUser |where-object {$_.UserPrincipalName -like "*@demoA.com.hk"} | Select-Object Userprincipalname, Displayname, Islicensed,count | Export-Csv C:\demoA_EmailAccountList-$date.csv -NoTypeInformation
$bdomainlist = Get-MsolUser |where-object {$_.UserPrincipalName -like "*demoB.com.hk"} | Select-Object Userprincipalname, Displayname, Islicensed,count | Export-Csv C:\demoB_EmailAccountList-$date.csv -NoTypeInformation
$cdomainlist = Get-MsolUser |where-object {$_.UserPrincipalName -like "*demoC..com.hk"} | Select-Object Userprincipalname, Displayname, Islicensed,count | Export-Csv C:\demoC_EmailAccountList-$date.csv -NoTypeInformation

#Count Data
$counta = (Get-MsolUser |where-object {$_.UserPrincipalName -like "*@demoA.com.hk"} | Select-Object Userprincipalname, Displayname, Islicensed).count
$countb = (Get-MsolUser |where-object {$_.UserPrincipalName -like "*@demoB.com.hk"} | Select-Object Userprincipalname, Displayname, Islicensed).count
$countc = (Get-MsolUser |where-object {$_.UserPrincipalName -like "*demoC.com.hk"} | Select-Object Userprincipalname, Displayname, Islicensed).count

#Set Mail 
$From = "Sys.admin@demo.com.hk"
$To = "it.support@demo.com.hk"
$Cc = "it_manager@demo.com.hk"
$Attachment = "demoA_EmailAccountList-$date.csv","demoB_EmailAccountList-$date.csv","demoC_EmailAccountList-$date.csv"
$Month = Get-Date -UFormat %b
$Subject = "Monthly Email Account Report of $Month"
$Body = @"
Dear Team </br>
This Monthly Email Account Report of $Month 
<br> </br>
demoA User count $countHKG<br></br>
demoB User count $countTH<br></br>
demoC User count $countDCIPA<br></br>
<br></br><br></br><br></br>
<br><h6>The Mail send from automatically system by Powershell</h6></br>
"@
$SMTPServer = "smtp.office365.com"
$SMTPPort = "587"
Send-MailMessage -From $From -to $To -cc $cc  -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $cred -Attachments $Attachment

#End PSSession
Remove-PSSession $s


#End PSSession
Remove-PSSession $s
