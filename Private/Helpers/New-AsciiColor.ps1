[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseShouldProcessForStateChangingFunctions',
    '',
    Justification = 'This function returns an ANSI-formatted string and does not change system state.'
)]
param()

function New-AsciiColor {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [AllowEmptyString()]
        [string]$String,

        [Parameter(Position = 1)]
        [ValidateRange(0, 255)]
        [int]$Color = 15,

        [ValidateRange(0, 255)]
        [int]$BackgroundColor,

        [ValidateSet('Bold', 'Dim', 'Italic', 'Underline', 'Blink', 'Reverse', 'Hidden', 'Strikethrough')]
        [string[]]$Format = @()
    )

    process {
        if ([string]::IsNullOrEmpty($String)) {
            return $String
        }

        $escape = [char]27
        $codes = [System.Collections.Generic.List[string]]::new($Format.Count + 2)
        $styleCodes = @{
            Bold          = '1'
            Dim           = '2'
            Italic        = '3'
            Underline     = '4'
            Blink         = '5'
            Reverse       = '7'
            Hidden        = '8'
            Strikethrough = '9'
        }

        foreach ($style in $Format) {
            $codes.Add($styleCodes[$style])
        }

        $codes.Add("38;5;$Color")
        if ($PSBoundParameters.ContainsKey('BackgroundColor')) {
            $codes.Add("48;5;$BackgroundColor")
        }

        return '{0}[{1}m{2}{0}[0m' -f $escape, ($codes -join ';'), $String
    }
}
