$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = get-location
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $false
$watcher.NotifyFilter = 
  [System.IO.NotifyFilters]::FileName -bor 
  [System.IO.NotifyFilters]::LastWrite 

while($TRUE){
  $result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::All, 1000);
  if ($result.TimedOut -or -not $result.Name.EndsWith(".pony")) { continue; }
  
  clear
  ponyc -d test
  if ($?) { ./test }
}