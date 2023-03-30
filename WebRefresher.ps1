while(1) { # Loop forever
    sleep -Seconds 5
    $wshell = New-Object -ComObject wscript.shell 
    if($wshell.AppActivate('Chrome')) { # Switch to Chrome
    $wshell.SendKeys('{F5}')  # Send F5 (Refresh)
    } else { break; } # Chrome not open, exit the loop
}