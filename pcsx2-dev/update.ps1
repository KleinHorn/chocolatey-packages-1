Import-Module AU
Import-Module Wormies-AU-Helpers

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            '(?i)(^\s*\$file32sse4\s*=\s*)(.*)' = "`$1Join-Path `$toolsDir '$($Latest.FileName32sse4)'"
            '(?i)(^\s*\$file64sse4\s*=\s*)(.*)' = "`$1Join-Path `$toolsDir '$($Latest.FileName64sse4)'"
            '(?i)(^\s*\$file32avx2\s*=\s*)(.*)' = "`$1Join-Path `$toolsDir '$($Latest.FileName32avx2)'"
            '(?i)(^\s*\$file64avx2\s*=\s*)(.*)' = "`$1Join-Path `$toolsDir '$($Latest.FileName64avx2)'"
        }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+x32sse4:).*"            = "`${1} $($Latest.URL32sse4)"
            "(?i)(checksum32sse4:).*"        = "`${1} $($Latest.Checksum32sse4)"
            "(?i)(\s+x64sse4:).*"            = "`${1} $($Latest.URL64sse4)"
            "(?i)(checksum64sse4:).*"        = "`${1} $($Latest.Checksum64sse4)"  
            "(?i)(\s+x32avx2:).*"            = "`${1} $($Latest.URL32avx2)"
            "(?i)(checksum32avx2:).*"        = "`${1} $($Latest.Checksum32avx2)"
            "(?i)(\s+x64avx2:).*"            = "`${1} $($Latest.URL64avx2)"
            "(?i)(checksum64avx2:).*"        = "`${1} $($Latest.Checksum64avx2)"            
        }
	}
}

function global:au_BeforeUpdate {
    $Latest.URL32 = $Latest.URL32sse4
    $Latest.URL64 = $Latest.URL64sse4
        
    Get-RemoteFiles -Purge -NoSuffix
    
    $Latest.FileName32sse4 = $Latest.Filename32
    $Latest.FileName64sse4 = $Latest.Filename64
    $Latest.Checksum32sse4 = $Latest.Checksum32
    $Latest.Checksum64sse4 = $Latest.Checksum64
    
    $Latest.URL32 = $Latest.URL32avx2
    $Latest.URL64 = $Latest.URL64avx2
        
    Get-RemoteFiles -NoSuffix
    
    $Latest.FileName32avx2 = $Latest.Filename32
    $Latest.FileName64avx2 = $Latest.Filename64
    $Latest.Checksum32avx2 = $Latest.Checksum32
    $Latest.Checksum64avx2 = $Latest.Checksum64
    
}

function global:au_GetLatest {
	$download_page = Invoke-WebRequest -Uri 'https://github.com/PCSX2/pcsx2/releases' -UseBasicParsing
    
	$regex32sse4        = "pcsx2-v[\d\.]*-windows-32bit-SSE4.7z"
    $regex64sse4        = "pcsx2-v[\d\.]*-windows-64bit-SSE4.7z"
    $url32sse4          = 'https://github.com' + ($download_page.links | ? href -match $regex32sse4 | select -First 1 -expand href)
    $url64sse4          = 'https://github.com' + ($download_page.links | ? href -match $regex64sse4 | select -First 1 -expand href)
    
    $regex32avx2        = "pcsx2-v[\d\.]*-windows-32bit-AVX2.7z"
    $regex64avx2        = "pcsx2-v[\d\.]*-windows-64bit-AVX2.7z"
    $url32avx2          = 'https://github.com' + ($download_page.links | ? href -match $regex32avx2 | select -First 1 -expand href)
    $url64avx2          = 'https://github.com' + ($download_page.links | ? href -match $regex64avx2 | select -First 1 -expand href)
	
	$version   = ($url32sse4 -split "/" | select -Last 1 -Skip 1).trim("v") + '-dev'
	
	return @{ 
        Version = $version
        FileType = "7z"
        URL32sse4 = $url32sse4
        URL64sse4 = $url64sse4
        URL32avx2 = $url32avx2
        URL64avx2 = $url64avx2
    }
}

Update-Package -ChecksumFor none
