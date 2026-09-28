# This script starts a local HTTP server on the specified port
# and redirects incoming requests to the specified destination URL.
# It also logs information about the server and incoming connections.

function Write-Info {
    param ([string] $Message)

    Write-Host "[$([System.DateTime]::Now)] [INFO] $($message)"
}

function Write-Error {
    param ([string] $Message)

    Write-Host "[$([System.DateTime]::Now)] [ERROR] $($message)"
}

$redirectUrl = Read-Host "Type the destination URL"
$serverPort = Read-Host "Type the server port"
$localWifiIP = $(Get-NetIPConfiguration -InterfaceAlias "Wi-fi").IPv4Address.IPAddress
$localEthernetIP = $(Get-NetIPConfiguration -InterfaceAlias "Ethernet").IPv4Address.IPAddress

$server = [System.Net.HttpListener]::new()
$server.Prefixes.Add("http://+:$($serverPort)/")

try {
    $server.Start()
    Write-Info -Message "Server is running on all interfaces on port $(serverPort) (including IPs: $($localWifiIP), $($localEthernetIP))"

    while ($server.IsListening) {
        $context = $server.GetContext()
        $userIP = $context.Request.RemoteEndpoint.Address
        Write-Info -Message "Received connection from $($userIP)"

        $context.Response.StatusCode = 302
        $context.Response.RedirectLocation = $redirectUrl
        $context.Response.Close()
    }
}
catch [System.Net.HttpListenerException] {
    Write-Error -Message "An exception occurred while trying to start server! $($_.Exception.Message)" 
}
finally {
    $server.Close()
}