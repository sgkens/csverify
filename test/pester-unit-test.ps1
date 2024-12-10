import-module -name .\

BeforeAll {

}

Describe "csverify.cmdlets" {
  
    it "New-CheckSum Should Return a string" {
        (New-CheckSum -Path .\).GetType().Name | should -be "String"
    }
    it "Read-CheckSum Should Return a string" {
        (New-CheckSum -Path .\).GetType().Name | should -be "String"
    }
    it "New-VerificationFile Should Return a string" {
        (New-VerificationFile).GetType().Name | should -be "Object[]"
    }
    it "Test-Verification Should Return a string" {
        (Test-Verification).GetType().Name | should -be "Object[]"
    }

}