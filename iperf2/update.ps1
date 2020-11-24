﻿Import-Module AU
Import-Module Wormies-AU-Helpers

function global:au_SearchReplace {
    @{
        "tools\VERIFICATION.txt" = @{
            "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
            "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
        }
	}
}

function global:au_BeforeUpdate() {
	Get-RemoteFiles -Purge -NoSuffix -FileNameBase 'iperf2'
}


function global:au_GetLatest {
	$rss_page = Invoke-RestMethod -Uri https://sourceforge.net/projects/iperf2/rss?path=/ -UseBasicParsing
    $rss_entry= $rss_page | ? link -match 'iperf-2.0.14a-.*-win\.exe' | select -First 1
    $orig_url = $rss_entry.link
    $url      = Get-RedirectedUrl -url $orig_url
    
    
    $main_version = '2.0.14.1001-alpha'
    $date         = ([dateTime][string]::Join("-",($rss_entry.pubDate -split " " | select -First 3 -Skip 1))).ToString("yyyyMMdd")
    $version      = $main_version + $date
    
    $useragent = [Microsoft.PowerShell.Commands.PSUserAgent]::Firefox
    
	return @{ 
        Version  = $version
        URL32    = $url
        FileType = 'exe'
        Options  = @{ Headers = @{ 'User-Agent' = $useragent } }
    }
}

Update-Package -ChecksumFor none