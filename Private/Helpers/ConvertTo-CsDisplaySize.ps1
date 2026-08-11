function ConvertTo-CsDisplaySize {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, [long]::MaxValue)]
        [long]$Bytes
    )

    $value = if ($Bytes -lt 1MB) {
        [decimal]$Bytes / 1KB
    }
    elseif ($Bytes -lt 1GB) {
        [decimal]$Bytes / 1MB
    }
    elseif ($Bytes -lt 1TB) {
        [decimal]$Bytes / 1GB
    }
    elseif ($Bytes -lt 1PB) {
        [decimal]$Bytes / 1TB
    }
    else {
        [decimal]$Bytes / 1PB
    }

    $unit = if ($Bytes -lt 1MB) {
        'KB'
    }
    elseif ($Bytes -lt 1GB) {
        'MB'
    }
    elseif ($Bytes -lt 1TB) {
        'GB'
    }
    elseif ($Bytes -lt 1PB) {
        'TB'
    }
    else {
        'PB'
    }

    $rounded = [math]::Round($value, 2)
    return '{0}{1}' -f $rounded.ToString('0.00', [System.Globalization.CultureInfo]::InvariantCulture), $unit
}
