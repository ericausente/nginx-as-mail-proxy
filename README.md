# nginx-as-mail-proxy
This is to simulate the integration of NGINX as a mail proxy with OAuth authentication through Red Hat SSO (Keycloak) before accessing a mail server (mimicking Google Workspace)

## Prerequisites:
- Docker: Ensure Docker is installed for container management.
- NGINX Plus: Since some advanced features might be needed, NGINX Plus would be a better choice.
- Mail Server Docker Image: Use a basic SMTP/IMAP server image for simulating Google Workspace.
- Network Setup: Make sure all these components can communicate with each other.
- Red Hat SSO (Keycloak): Set up a Keycloak server for OAuth (To-do list)


## Step-by-Step Setup:

### Testing SMTP

To test your SMTP server:
Step 1: Install Swaks

Swaks is a command-line SMTP client used for testing. Install it on your local machine:

Ubuntu/Debian:
```
sudo apt-get install swaks
```

macOS (using Homebrew):
```
brew install swaks
```

Step 2: Send a Test Email
Use Swaks to send a test email:
```
swaks --to test@example.com --from you@yourdomain.com --server your-aws-instance-public-ip --port 25
```

Replace test@example.com with the recipient's email, you@yourdomain.com with your email, and your-aws-instance-public-ip with your AWS instance's public IP.


### Using MailHog

MailHog is a simple SMTP server suitable for development and testing. It can be run via Docker.
Running MailHog
```
docker run -d -p 8025:8025 -p 1025:1025 mailhog/mailhog
```

This command starts MailHog and exposes two ports:
- 1025: SMTP server for sending emails
- 8025: Web interface to view caught emails. Access it at http://your-server-ip:8025.

Testing SMTP with MailHog
Send Email to MailHog:
Use Swaks or a similar SMTP client to send an email to MailHog.
```
swaks --to test@example.com --from sender@example.com --server your-server-ip --port 1025
```

Replace your-server-ip with your server's IP or localhost.

Check MailHog's Web Interface:
Open http://your-server-ip:8025 in a browser to view the sent email.

Sending Test Email

Example command to send a test email using Swaks:
```
swaks --to kushikimi.ausente@example.com --from sender@example.com --server 54.169.103.XX --port 1025
```

This command will display the SMTP interaction, confirming the email's successful transmission.


Mastering SMTP (Simple Mail Transfer Protocol) and IMAP (Internet Message Access Protocol) using Telnet is a great way to understand the underlying mechanics of email transmission and retrieval. However, it's important to note that Telnet, being a plaintext protocol, isn't secure for transmitting sensitive information like email credentials. For learning purposes, ensure you're working in a controlled and secure environment.

To simulate sending an email via SMTP using Telnet, you can convert the Swaks (Swiss Army Knife SMTP) command you provided into Telnet commands. Here's how you can do it:

```
telnet your-server-ip 1025
```

Greet the Mail Server with HELO or EHLO:
```
EHLO ip-172-16-15-155.ap-southeast-1.compute.internal
```

Set the Sender Address:
```
MAIL FROM:<sender@example.com>
```

Set the Recipient Address:
```
RCPT TO:<kushikimi.ausente@gmail.com>
```
Compose the Message:
```
DATA
```

After entering DATA, write your message. Typically, you start with headers like Subject:, followed by a blank line, and then the body of your message.
```
Date: Thu, 30 Nov 2023 11:01:33 +0000
To: kushikimi.ausente@gmail.com
From: sender@example.com
Subject: test Thu, 30 Nov 2023 11:01:33 +0000
Message-Id: <20231130110133.030313@ip-172-16-15-155.ap-southeast-1.compute.internal>
X-Mailer: swaks v20170101.0 jetmore.org/john/code/swaks/
```

End the Message:
```
<ENTER>
This is a test E-mail.
<ENTER>
.
```

Typing a period (.) on a line by itself ends the message input.

Close the Connection:
```
QUIT
```

Sample output: 
```
$ telnet 54.169.103.XX 1025
Trying 54.169.103.XX...
Connected to 54.169.103.XX.
Escape character is '^]'.
220 mailhog.example ESMTP MailHog
EHLO ip-172-16-15-155.ap-southeast-1.compute.internal
250-Hello ip-172-16-15-155.ap-southeast-1.compute.internal
250-PIPELINING
250 AUTH PLAIN
MAIL FROM:<sender@example.com>
250 Sender sender@example.com ok
RCPT TO:<kushikimi.ausente@gmail.com>
250 Recipient kushikimi.ausente@gmail.com ok
DATA
354 End data with <CR><LF>.<CR><LF>
Date: Thu, 30 Nov 2023 11:01:33 +0000
To: kushikimi.ausente@gmail.com
From: sender@example.com
Subject: test Thu, 30 Nov 2023 11:01:33 +0000
Message-Id: <20231130110133.030313@ip-172-16-15-155.ap-southeast-1.compute.internal>
X-Mailer: swaks v20170101.0 jetmore.org/john/code/swaks/

This is a test mailing

.
250 Ok: queued as Ia1s2drgDIcEcZNz5jupyP6Cr7Y6JfAwUJnXgL0YGDE=@mailhog.example
QUIT
221 Bye
Connection closed by foreign host.
```


# SMTP/IMAP 2-in-1 Server 
I set up an SMTP/IMAP server using [docker-testing-mail](https://github.com/jbchouinard/docker-testing-mail) and testing it through Telnet and OpenSSL. The server was deployed on an AWS EC2 instance with appropriate security group configurations to allow ports 143 (IMAP), 993 (IMAPS), and 25 (SMTP).

## Testing Procedure

Sending Mail via SMTP (Port 25)
Telnet Connection to SMTP Server:
```
[ec2-user@ip-172-16-15-155 ~]$ telnet 54.169.103.66 25
Trying 54.169.103.66...
Connected to 54.169.103.66.
Escape character is '^]'.
220 5f31557dd9ad ESMTP Postfix (Ubuntu)
EHLO 54.169.103.66
250-5f31557dd9ad
...
250 SMTPUTF8
MAIL FROM:<sender@example.com>
250 2.1.0 Ok
RCPT TO:<alice@local.test>
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
...
.
250 2.0.0 Ok: queued as 02CB559609F8
QUIT
221 2.0.0 Bye
Connection closed by foreign host.
```

Reading Mail via IMAP (Port 993)
OpenSSL Connection to IMAP Server:
```
[ec2-user@ip-172-16-15-155 ~]$ openssl s_client -connect 54.169.103.66:993
...
* OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE IDLE AUTH=PLAIN AUTH=LOGIN] Dovecot ready.
a login alice@local.test password123
a OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE IDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS THREAD=ORDEREDSUBJECT MULTIAPPEND URL-PARTIAL CATENATE UNSELECT CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS BINARY MOVE SPECIAL-USE] Logged in
a select INBOX
* FLAGS (\Answered \Flagged \Deleted \Seen \Draft)
...
* 1 EXISTS
a fetch 1:* full
* 1 FETCH (FLAGS (\Recent) INTERNALDATE "02-Dec-2023 07:51:34 +0000" RFC822.SIZE 755 ENVELOPE ("Thu, 30 Nov 2023 11:01:33 +0000" "test Thu, 30 Nov 2023 11:01:33 +0000" ((NIL NIL "sender" "example.com")) ((NIL NIL "sender" "example.com")) ((NIL NIL "sender" "example.com")) ((NIL NIL "kushikimi.ausente" "gmail.com")) NIL NIL NIL "<20231130110133.030313@ip-172-16-15-155.ap-southeast-1.compute.internal>") BODY ("text" "plain" ("charset" "us-ascii") NIL NIL "7bit" 26 2))
a OK Fetch completed (0.002 + 0.000 secs).
```
