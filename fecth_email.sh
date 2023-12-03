#!/usr/bin/expect

# Set variables
set timeout -1
set sender "sender@example.com"
set recipient "alice@local.test"
set server "54.169.103.66"
set port "25"

# Start telnet session
spawn telnet $server $port

# Expect the server to be ready
expect "220"

# Say hello to the server
send -- "EHLO $server\r"

# Wait for the server to accept the EHLO
expect "250"

# Set the sender email
send -- "MAIL FROM:<$sender>\r"

# Wait for the sender to be accepted
expect "250"

# Set the recipient email
send -- "RCPT TO:<$recipient>\r"

# Wait for the recipient to be accepted
expect "250"

# Start sending the data
send -- "DATA\r"

# Wait for the server's go-ahead
expect "354"

# Send the email data
send -- "Subject: Test Email From Bash Script\r"
send -- "\r"
send -- "This is a test email sent from a bash script using telnet.\r"
send -- ".\r"

# Wait for the server to accept the data
expect "250"

# Quit the session
send -- "QUIT\r"

# Close the telnet session
expect "221"
