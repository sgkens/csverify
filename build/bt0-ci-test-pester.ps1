# Pester Configration settings
# _----------------------------_
# ------------------------------
# Invoke-Pester -CodeCoverage .\libs\*.psm1 -CodeCoverageOutputFile 'Coverage.xml' -CodeCoverageOutputFileFormat JaCoCo -script .\BT0-CI-Test-Pester.ps1 -PassThru
$pesterConfig = New-PesterConfiguration -hashtable @{
  CodeCoverage = @{ 
    Enabled               = $true
    OutputFormat          = 'JaCoCo'
    OutputPath            = 'coverage.xml'
    OutputEncoding        = 'utf8'
    CoveragePercentTarget = 85
    path                  = ".\libs\*.psm1",".\*.psm1"
  }
  Run = @{
    # PassThru = $true
    #scriptblock = {'.\test\Test-Unit-Pester.ps1'}
    Path     = '.\test\pester-unit-test.ps1';
  }
}
Invoke-Pester -Configuration $pesterConfig
