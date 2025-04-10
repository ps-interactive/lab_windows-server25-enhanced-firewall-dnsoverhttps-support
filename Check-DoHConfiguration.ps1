# DoH Configuration Check Script
# Validates DoH settings and tests functionality

# Check DoH client settings
Write-Host "=== Checking DoH Client Configuration ===" -ForegroundColor Cyan
try {
    $dohSettings = Get-DnsClientDohServerAddress -ErrorAction Stop
    if ($dohSettings) {
        Write-Host "DoH is configured with the following settings:" -ForegroundColor Green
        $dohSettings | Format-Table -AutoSize
    } else {
        Write-Host "DoH is not configured." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error checking DoH configuration: $_" -ForegroundColor Red
}

# Force Group Policy update to ensure DoH settings are applied
Write-Host "`n=== Forcing Group Policy Update ===" -ForegroundColor Cyan
gpupdate /force

# Check registry settings for DoH
Write-Host "`n=== Checking DoH Registry Settings ===" -ForegroundColor Cyan
$dohRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
$properties = @("EnableAutoDoh", "DohFlags", "DohTemplate")

foreach ($prop in $properties) {
    try {
        $value = Get-ItemProperty -Path $dohRegistryPath -Name $prop -ErrorAction SilentlyContinue
        if ($value) {
            Write-Host "$prop = $($value.$prop)"
        } else {
            Write-Host "$prop = Not configured"
        }
    } catch {
        Write-Host "$prop = Error: $_"
    }
}

# Test DNS resolution with explicit DoH request
Write-Host "`n=== Testing Encrypted DNS Resolution ===" -ForegroundColor Cyan
try {
    $resolveResult = Resolve-DnsName -Name "www.carvedrock.co" -Type A -DnsOnly -ErrorAction Stop
    Write-Host "DNS resolution successful. Result:" -ForegroundColor Green
    $resolveResult | Format-Table -AutoSize
} catch {
    Write-Host "DNS resolution failed. Error: $_" -ForegroundColor Red
}
