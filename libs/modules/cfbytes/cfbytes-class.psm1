<#  
* Name: cfbytes
* Description: Convert a byte array to human-readable form. decimals, json, object
* Version: 1.0
* Author: gsnow
* Date: 1/1/2017 
* Copyright: Copyright (c) 2022 gsnow
#>
class cfbytes {

    # * 1024 kylobyte
    # * 1048576 1 megabyte
    # * 1073741824 1 gigabyte
    # * 1099511627776 1 terabyte
    # * 1125899906842624 1 petabyte
    hidden static [int] $byte = 1
    hidden static [int] $kylobyte = 1024
    hidden static [long] $megabyte = 1048576
    hidden static [long] $gigabyte = 1073741824
    hidden static [long] $terabyte = 1099511627776
    hidden static [long] $petabyte = 1125899906842624
    static [string] $TOKB = 1KB;
    static [string] $TOMB = 1MB;
    static [string] $TOGB = 1GB;
    static [string] $TOTB = 1TB;
    static [string] $TOPB = 1PB;
    static [int]    $round = 2 # default is 1 decimal place
    static [switch] $caption = $false # default is false
    <# =====================================================
    ! Function: convert
    ? Description: Convertes and returns the bytes in a human readable format.
    * @param [int] $bytes The bytes to convert. 
    * @param [string] $unit The unit to convert to.
    #>   
    static [string] convert( [long]$bytes, [string]$unit) {
        [decimal] $covertedbytes = 0
        [string] $formattedBytes = ""
        switch ($unit) {

            'bt' {
                $covertedbytes = [math]::round(($bytes / [cfbytes]::TOKB), [cfbytes]::round);
                if ($covertedbytes -eq 0) {
                    $formattedBytes = "0.00 KB"
                }
                else {
                    $formattedBytes = ($covertedbytes).tostring()
                    $formattedBytes = "$formattedBytes KB"
                }
            }
            'kb' {
                $covertedbytes = [math]::round(($bytes / [cfbytes]::TOKB), [cfbytes]::round);
                if ([cfbytes]::caption -eq $true) { 
                    $formattedBytes = ($covertedbytes).tostring()
                    $formattedBytes = "$formattedBytes KB" 
                }
                else {
                    $formattedBytes = ($covertedbytes).tostring()
                }
            }
            'mb' {
                $covertedbytes = [math]::round(($bytes / [cfbytes]::TOMB), [cfbytes]::round);
                if ([cfbytes]::caption -eq $true) { 
                    $formattedBytes = ($covertedbytes).tostring()
                    $formattedBytes = "$formattedBytes MB" 
                }
                else {
                    $formattedBytes = ($covertedbytes).tostring()
                }
            }
            'gb' {
                $covertedbytes = [math]::round(($bytes / [cfbytes]::TOGB), [cfbytes]::round);
                if ([cfbytes]::caption -eq $true) { 
                    $formattedBytes = ($covertedbytes).tostring()
                    $formattedBytes = "$formattedBytes GB" 
                }
                else {
                    $formattedBytes = ($covertedbytes).tostring()
                }
            }
            'tb' {
                $covertedbytes = [math]::round(($bytes / [cfbytes]::TOTB), [cfbytes]::round);
                if ([cfbytes]::caption -eq $true) { 
                    $formattedBytes = ($covertedbytes).tostring()
                    $formattedBytes = "$formattedBytes TB" 
                }
                else {
                    $formattedBytes = ($covertedbytes).tostring()
                }
            }
            'pb' {
                $covertedbytes = [math]::round(($bytes / [cfbytes]::TOPB), [cfbytes]::round);
                if ([cfbytes]::caption -eq $true) { 
                    $formattedBytes = ($covertedbytes).tostring()
                    $formattedBytes = "$formattedBytes PB" 
                }
                else {
                    $formattedBytes = ($covertedbytes).tostring()
                }
            }
        }
        
        return $formattedBytes
    }
    <# =====================================================
    ! Function: convertAuto
    ? Description: Convertes and returns the bytes in a human readable format, auto attached to the unit.
    * @param [int] $bytes The bytes to convert. 
    * @param [string] $unit The unit to convert to.
    #//TODO: change from if to switch statement
    #>   
    static [string] ConvertAuto( [long]$bytes ) {
        [decimal] $covertedbytes = 0
        [string] $formattedBytes = ""
        if ($bytes -gt [cfbytes]::byte) { 
            $covertedbytes = [math]::round(($bytes / [cfbytes]::TOKB), [cfbytes]::round);
            if ($covertedbytes -eq 0) {
                $formattedBytes = "0.00 KB"
            }
            else {
                $formattedBytes = ($covertedbytes).tostring()
                $formattedBytes = "$formattedBytes KB"
            }
        }
        if ($bytes -gt [cfbytes]::kylobyte) { 
            $covertedbytes = [math]::round(($bytes / [cfbytes]::TOKB), [cfbytes]::round);
            $formattedBytes = ($covertedbytes).tostring()
            $formattedBytes = "$formattedBytes KB" 
        }
        if ($bytes -gt [cfbytes]::megabyte -and $bytes -lt [cfbytes]::gigabyte) { 
            $covertedbytes = [math]::round(($bytes / [cfbytes]::TOMB), [cfbytes]::round);
            $formattedBytes = ($covertedbytes).tostring()
            $formattedBytes = "$formattedBytes MB" 
        }
        if ($bytes -gt [cfbytes]::gigabyte -and $bytes -lt [cfbytes]::terabyte) { 
            $covertedbytes = [math]::round(($bytes / [cfbytes]::TOGB), [cfbytes]::round);
            $formattedBytes = ($covertedbytes).tostring()
            $formattedBytes = "$formattedBytes GB" 
        }
        if ($bytes -gt [cfbytes]::terabyte -and $bytes -lt [cfbytes]::petabyte) { 
            $covertedbytes = [math]::round(($bytes / [cfbytes]::TOTB), [cfbytes]::round);
            $formattedBytes = ($covertedbytes).tostring()
            $formattedBytes = "$formattedBytes TB" 
        }
        if ($bytes -gt [cfbytes]::petabyte) { 
            $covertedbytes = [math]::round(($bytes / [cfbytes]::TOPB), [cfbytes]::round);
            $formattedBytes = ($covertedbytes).tostring()
            $formattedBytes = "$formattedBytes PB" 
        }

        return $formattedBytes
    }
    
}


# Function examples
# ------------------
# * [cfbytes]::round = 1
# * [cfbytes]::caption = $true
# * [cfbytes]::convertAuto(170001555344)
# * [cfbytes]::convert(170001555344, 'mb')

