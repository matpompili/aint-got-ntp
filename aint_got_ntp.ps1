# MIT License

# Copyright (c) 2022 Matteo Pompili <https://github.com/matpompili>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

Start-Transcript .\aint_got_ntp_log.txt

$ie = New-Object -ComObject InternetExplorer.Application
$ie.Navigate("https://time.is/")
# Wait until the browser is not busy
Do { Start-Sleep -m 1000 } Until (!$ie.Busy)
echo "https://time.is/ is open. Waiting five more sec for synchronization to happen."
Start-Sleep -m 5000

# Read the sync result
$sync_result = $ie.Document.getElementById("syncH").innerHTML()
echo ("Read from time.is: " + $sync_result)

# Check the sync result
switch -regex ($sync_result) {
  'Your clock is (\d+\.\d+) seconds behind' {
    $differnce = select-string 'Your clock is (\d+\.\d+) seconds behind' -inputobject $sync_result
    $seconds = $differnce.Matches.groups[1].value
    $cmd = "Set-Date -Adjust 00:00:" + $seconds
    echo ("Synchronization command: " + $cmd)
    iex $cmd }
  'Your clock is \d+\.\d+ seconds ahead' {
    $differnce = select-string 'Your clock is (\d+\.\d+) seconds ahead' -inputobject $sync_result
    $seconds = $differnce.Matches.groups[1].value
    $cmd = "Set-Date -Adjust -00:00:" + $seconds
    echo ("Synchronization command: " + $cmd)
    iex $cmd }
  'Your clock is (\d+) minute[s]? and (\d+\.\d+) seconds ahead.' {
    $differnce = select-string 'Your clock is (\d+) minute[s]? and (\d+\.\d+) seconds ahead.' -inputobject $sync_result
    $minutes = $differnce.Matches.groups[1].value
    $seconds = $differnce.Matches.groups[2].value
    $cmd = "Set-Date -Adjust -00:" + $minutes + ":" + $seconds
    echo ("Synchronization command: " + $cmd)
    iex $cmd }
  'Your clock is (\d+) minute[s]? and (\d+\.\d+) seconds behind.' {
    $differnce = select-string 'Your clock is (\d+) minute[s]? and (\d+\.\d+) seconds behind.' -inputobject $sync_result
    $minutes = $differnce.Matches.groups[1].value
    $seconds = $differnce.Matches.groups[2].value
    $cmd = "Set-Date -Adjust 00:" + $minutes + ":" + $seconds
    echo ("Synchronization command: " + $cmd)
    iex $cmd }
  'Your time is exact!' {
    echo 'Time is exact, no action taken.' }      
  default {
    echo 'Error. Regex did not match anything match.' }
}

# Close Internet Explorer
$ie.quit()

Stop-Transcript