# VPS server setup

One-time manual steps to prepare the VPS before the first `make deploy`.

## Assumptions

- Ubuntu 22.04 LTS VPS
- SSH access as a non-root user with sudo
- Domain DNS already pointing to the VPS IP

## Steps

### 1. Install Nginx and Certbot

```bash
sudo apt update && sudo apt install -y nginx certbot python3-certbot-nginx
```

### 2. Create the deploy directory

```bash
sudo mkdir -p /var/www/valenciapodcaststudio
sudo chown $USER:www-data /var/www/valenciapodcaststudio
sudo chmod 755 /var/www/valenciapodcaststudio
```

### 3. Install the Nginx config

```bash
sudo cp deploy/nginx.conf.sample /etc/nginx/sites-available/valenciapodcaststudio.com
sudo ln -s /etc/nginx/sites-available/valenciapodcaststudio.com /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### 4. Obtain TLS certificate (Let's Encrypt)

```bash
sudo certbot --nginx -d valenciapodcaststudio.com -d www.valenciapodcaststudio.com
```

Certbot will edit the Nginx config to fill in the certificate paths and reload automatically.

### 5. Auto-renew

Certbot installs a systemd timer by default. Verify:

```bash
sudo systemctl status certbot.timer
```

### 6. SSH key auth for deploys

Add the Mac's public key to `~/.ssh/authorized_keys` on the VPS so `make deploy` runs without a password prompt:

```bash
# On the Mac:
ssh-copy-id deploy@YOUR_VPS_IP
```

### 7. First deploy

Fill in `.env.deploy` (copy from `.env.deploy.example`), then:

```bash
make deploy
```

Verify at `https://valenciapodcaststudio.com`.
