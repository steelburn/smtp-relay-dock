# smtp-relay
This is a basic docker image consisting of postfix, configured as closed SMTP relay.
It inspect both sender domain & recipient domains to validate whether to allow sending of emails to the recipients.

## Use case
This docker image can be used in an environment where you need a simple relay placed on the Internet, while at the same time making sure it's not opened to anyone to tap.

## Configuration 
You would need to edit the following files:

Filename   | Description
-----------|---------------
/app/config/relaydomain.map | Allowed recipient domains
/app/config/sender-whitelist.map | Allowed sender domains

## Mount Points
 There is only one mount point, ``/app/config`` to ensure you have persistent location to keep your config.

## Port exposed
Only one port exposed, port ``25``.
 
## How to run this image
You may use this image as a standalone image using
```bash
sudo docker volume create smtp-relay-data
sudo docker run -d -p 25:25 -v smtp-relay-data:/app/config steelburn\smtp-relay
```
For port (``-p``) parameter, you may replace the first ``25`` to your own port you would want to expose in the host, e.g: ``-p 2525:25``, as long as the second port is correct.

## About
Image prepared by @steelburn for own use. 

