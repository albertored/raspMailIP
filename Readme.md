# raspMailIP

**raspMailIP** is a simple script for receiving mails with updates of IP 
addresses changes from your Raspberry Pi.
It is particularly useful if for any reason you don't want to use web
services to have dynamic DNS but also in addition to these.

## Requirements

In order to send mails raspMailIP you need the *ssmtp* package. Install it using

`sudo apt-get install ssmtp`
    
and then modify the file `/etc/ssmtpssmtp.conf` with your preferred settings 
(in [this](http://www.havetheknowhow.com/Configure-the-server/Install-ssmtp.html) 
guide there is an example of configuration for a gmail account).

## Getting started

1. open the script with a text editor
2. modify the path to the directory in which you want to put the files with your IPs
3. modify the mail addresses
4. add the script to your `crontab` to be executed every *n* minutes and at reboot
with argument `reboot`. I personally run it every 5 minutes:

```
*/5 * * * * /path/to/script/./mail.sh update > /dev/null 2>&1
@reboot     /path/to/script/./mail.sh reboot > /dev/null 2>&1
```
