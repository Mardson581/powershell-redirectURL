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
$adaptersIP = (Get-NetIPAddress -AddressState Preferred -AddressFamily IPv4 -InterfaceAlias $(Get-NetAdapter).Name).IPAddress

$server = [System.Net.HttpListener]::new()
$server.Prefixes.Add("http://+:$($serverPort)/")

try {
    $server.Start()
    Write-Info -Message "Server is running on all interfaces on port $($serverPort) (including IPs $($adaptersIP))"
    Write-Info -Message "Send a GET request to /shutdown to stop the server"

    while ($server.IsListening) {
        $context = $server.GetContext()
        $userIP = $context.Request.RemoteEndpoint.Address
        Write-Info -Message "Received connection from $($userIP)"

        if ($context.Request.Url.LocalPath -eq "/shutdown") {
            Write-Info -Message "The user $($userIP) requested server shutdown"
            $context.Response.StatusCode = 200
            $context.Response.Close()
            $server.Close()
            exit
        }

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
