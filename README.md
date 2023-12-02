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
