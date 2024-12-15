<# Commit Fusion template file use to create large detailed commits or merge requests #>
$Params = @{
  GitUser          = "";
  GitGroup         = "";
  footer           = $false
  Type             = "";
  Scope            = "";
  Description      = "";
  Notes            = @()
  FeatureAdditions = @();
  BugFixes         = @();
  BreakingChanges  = @();
  FeatureNotes     = @();
}

# ACTIONS
# -------

# ConventionalCommit with params sent commit
New-Commit @Params

# ConventionalCommit with params sent commit
#New-Commit @Params | Set-Commit

# ConventionalCommit with params, written to changelog and sent commit
#New-Commit @Params | Format-FusionMD | Update-ChangeLog -logfile .\changelog.md | Set-Commit