function Format-CsProperty {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Value
    )

    $arrow = New-AsciiColor -String '>' -Color 51
    $property = New-AsciiColor -String $Value -Color 226
    return "$arrow - $property"
}

function Format-CsKeyValue {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Value
    )

    $open = New-AsciiColor -String '{' -Color 226
    $close = New-AsciiColor -String '}' -Color 226
    $keyText = New-AsciiColor -String $Key -Color 201
    $valueText = New-AsciiColor -String $Value -Color 226
    return "$(New-AsciiColor -String '>' -Color 51) $open key ($keyText) value ($valueText) $close"
}

function Format-CsFailedPath {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $pathText = New-AsciiColor -String $Path -Color 196
    $failedText = New-AsciiColor -String 'failed' -Color 196
    return "--x $pathText $failedText"
}
