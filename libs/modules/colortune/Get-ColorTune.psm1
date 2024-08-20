Function Get-ColorTune(){
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [parameter(mandatory=$true)]
        [string]$text,
        [parameter(mandatory=$false)]
        [ValidateSet(
            "blue",
            "yellow",
            "green",
            "red",
            "white",
            "black",
            "cyan",
            "magenta",
            "gray",
            "darkgray",
            "darkblue",
            "darkyellow",
            "darkgreen",
            "darkred",
            "darkcyan",
            "darkmagenta", ignorecase =$true)]
        $color = "white"
    )
    Begin{

    }
    process{
        if($PSVersionTable.PSVersion.Major -eq 5){
            # Define the escape sequence for color formatting
            $escapeSequence = [char]27
            # Define color codes
            $colorReset = "${escapeSequence}[0m"   # Reset color
            $colorRed = "${escapeSequence}[31m"    # Red
            $colorGreen = "${escapeSequence}[32m"  # Green
            $colorYellow = "${escapeSequence}[33m" # Yellow
            $colorBlue = "${escapeSequence}[34m"   # Blue
            $colorMagenta = "${escapeSequence}[35m" # Magenta
            $colorCyan = "${escapeSequence}[36m"   # Cyan
            $colorWhite = "${escapeSequence}[37m"  # White
            $colorDarkGray = "${escapeSequence}[90m" # Dark Gray
            $colorDarkRed = "${escapeSequence}[91m" # Dark Red
            $colorDarkGreen = "${escapeSequence}[92m" # Dark Green
            $colorDarkYellow = "${escapeSequence}[93m" # Dark Yellow
            $colorDarkBlue = "${escapeSequence}[94m" # Dark Blue
            $colorDarkMagenta = "${escapeSequence}[95m" # Dark Magenta
            $colorDarkCyan = "${escapeSequence}[96m" # Dark Cyan
            $colorBlack = "${escapeSequence}[97m" # Black

            switch($color){
                "red" { return "$colorRed$text$colorReset"}
                "yellow" { return "$colorYellow$text$colorReset"}
                "green" { return "$colorGreen$text$colorReset"}
                "blue" { return "$colorBlue$text$colorReset"}
                "white" { return "$colorWhite$text$colorReset"}
                "black" { return "$colorBlack$text$colorReset"}
                "cyan" { return "$colorCyan$text$colorReset"}
                "magenta" { return "$colorMagenta$text$colorReset"}
                "gray" { return "$colorDarkGray$text$colorReset"}
                "darkgray" { return "$colorDarkGray$text$colorReset"}
                "darkblue" { return "$colorDarkBlue$text$colorReset"}
                "darkyellow" { return "$colorDarkYellow$text$colorReset"}
                "darkgreen" { return "$colorDarkGreen$text$colorReset"}
                "darkred" { return "$colorDarkRed$text$colorReset"}
                "darkcyan" { return "$colorDarkCyan$text$colorReset"}
                "darkmagenta" { return "$colorDarkMagenta$text$colorReset"}
                default { return "$colorWhite$text$colorReset" }
            }
        }
        else{
            switch($color){
                "blue" { return "`e[34m$text`e[0m"}
                "yellow" { return "`e[33m$text`e[0m"}
                "green" { return "`e[32m$text`e[0m"}
                "red" { return "`e[31m$text`e[0m"}
                "white" { return "`e[37m$text`e[0m"}
                "black" { return "`e[30m$text`e[0m"}
                "cyan" { return "`e[36m$text`e[0m"}
                "magenta" { return "`e[35m$text`e[0m"}
                "gray" { return "`e[90m$text`e[0m"}
                "darkgray" { return "`e[90m$text`e[0m"}
                "darkblue" { return "`e[34m$text`e[0m"}
                "darkyellow" { return "`e[33m$text`e[0m"}
                "darkgreen" { return "`e[32m$text`e[0m"}
                "darkred" { return "`e[31m$text`e[0m"}
                "darkcyan" { return "`e[36m$text`e[0m"}
                "darkmagenta" { return "`e[35m$text`e[0m"}
                default { return "`e[37m$text`e[0m"}
            }
        }
    }
}
Export-ModuleMember -Function Get-ColorTune