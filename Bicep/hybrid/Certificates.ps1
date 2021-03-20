
$RootCertificateName="ContosoRootCertificate"
$ClientCertificateName="ContosoClientCertificate"

$RootCertificate = New-SelfSignedCertificate `
    -FriendlyName $RootCertificateName `
    -Subject "CN=$RootCertificateName" `
    -Type Custom `
    -KeySpec Signature `
    -KeyExportPolicy Exportable `
    -HashAlgorithm sha256 `
    -KeyLength 2048 `
    -KeyUsageProperty Sign `
    -KeyUsage CertSign `
    -CertStoreLocation 'Cert:\CurrentUser\My'

$ClientCertificate = New-SelfSignedCertificate `
    -FriendlyName $ClientCertificateName `
    -Subject "CN=$ClientCertificateName" `
    -Type Custom `
    -KeySpec Signature `
    -KeyExportPolicy Exportable `
    -HashAlgorithm sha256 `
    -KeyLength 2048 `
    -Signer $RootCertificate `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2") `
    -CertStoreLocation 'Cert:\CurrentUser\My'

Get-ChildItem Cert:\CurrentUser\My | 
    where {$_.Subject -eq "CN=$RootCertificateName" -or $_.Subject -eq "CN=$ClientCertificateName"} | 
    ft Subject, Issuer, Thumbprint

$RootCertPublicData=[System.Convert]::ToBase64String($RootCertificate.RawData)
$RootCertPublicData | clip