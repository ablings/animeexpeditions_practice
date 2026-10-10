param([string]$name, [int]$maxGB = 30, [int]$maxSec = 600)
$p = Get-Process RobloxStudioBeta | ? { $_.MainWindowTitle -like '*AE_export*' } | Select -First 1
$t0 = Get-Date
while ($true) {
  Start-Sleep 5; $p.Refresh()
  $f = Get-ChildItem "C:\Users\aroki\Documents\animeexp_practice\kit\ref_export" -Filter "$name.obj" -ErrorAction SilentlyContinue
  $gb = [math]::Round($p.WorkingSet64/1GB,1)
  if ($p.Responding -and $f) { "{0} done {1:N1} MB in {2:N0}s (peak RAM seen {3} GB)" -f $name, ($f.Length/1MB), ((Get-Date)-$t0).TotalSeconds, $gb; break }
  if ($gb -gt $maxGB) { "ABORT $name RAM $gb GB"; Stop-Process -Id $p.Id -Force; break }
  if (((Get-Date)-$t0).TotalSeconds -gt $maxSec) { "TIMEOUT $name RAM $gb GB"; break }
}
