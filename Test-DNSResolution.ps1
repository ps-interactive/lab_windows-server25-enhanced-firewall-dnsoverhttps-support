# DNS Resolution Test Script
# Function to test DNS resolution
function Test-DNSResolution {
    param (
        [string]$DomainName,
        [string]$RecordType = "A"
    )
    
    Write-Host "Testing resolution for $DomainName ($RecordType)..."
    try {
        $result = Resolve-DnsName -Name $DomainName -Type $RecordType -ErrorAction Stop
        Write-Host "  Success! Resolved to: $($result.IPAddress)"
        return $true
    }
    catch {
        Write-Host "  Failed! Error: $_"
        return $false
    }
}

# Test internal domain resolution
Write-Host "=== Testing Internal Domain Resolution ===" -ForegroundColor Cyan
Test-DNSResolution -DomainName "dc01.carvedrock.co"
Test-DNSResolution -DomainName "www.carvedrock.co"
