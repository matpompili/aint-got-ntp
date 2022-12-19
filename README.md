# aint-got-ntp
Synchronize Windows time without NTP.

Usually your computer automatically synchronizes its clock using the Network Time Protocol ([NTP](https://en.wikipedia.org/wiki/Network_Time_Protocol)). In some cases NTP does not work (for example your organization blocks the necessary ports), but you still have access to Internet.
In that case, and if you have administrator access on your computer, this script can be used to synchronize your Windows time to the time displayed by [time.is](https://time.is). 

To run it once, simply call the script in an administrator Powershell. Below an example of the output.
```
PS C:\> .\aint_got_ntp.ps1

Transcript started, output file is .\aint_got_ntp_log.txt
https://time.is/ is open. Waiting five more sec for synchronization to happen.
Read from time.is: Your clock is 3.0 seconds ahead.
Synchronization command: Set-Date -Adjust -00:00:3.0
Monday, December 19, 2022 10:33:11 AM
Transcript stopped, output file is C:\aint_got_ntp_log.txt
```

Your computer will probably get again out-of-sync by about one second every day, so you might want to run this script automatically using the Task Scheduler.
To set that up you can follow [this guide](https://social.technet.microsoft.com/wiki/contents/articles/53833.run-powershell-script-with-windows-task-scheduler.aspx).
