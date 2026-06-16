#!/bin/bash
# =============================================================================
# FILE: 01_install_elastic.sh
# PURPOSE: Install Elasticsearch 8.x and Kibana on Ubuntu Server 24.04 ARM64
# RUN AS: sudo bash 01_install_elastic.sh
# ENVIRONMENT: VMware Fusion on Apple Silicon (M1/M2/M3/M4/M5)
# TIME: ~10-15 minutes
# =============================================================================

set -e

echo "============================================="
echo " Elastic Stack 8.x Installer"
echo " Ubuntu Server 24.04 ARM64"
echo "============================================="

# -----------------------------------------------------------------------------
# STEP 1: Update system packages
# -----------------------------------------------------------------------------
echo "[1/7] Updating system packages..."
apt-get update -y && apt-get upgrade -y
apt-get install -y curl wget apt-transport-https gnupg

# -----------------------------------------------------------------------------
# STEP 2: Import Elastic GPG key and add repository
# -----------------------------------------------------------------------------
echo "[2/7] Adding Elastic repository..."

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch \
  | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] \
https://artifacts.elastic.co/packages/8.x/apt stable main" \
  | tee /etc/apt/sources.list.d/elastic-8.x.list

apt-get update -y

# -----------------------------------------------------------------------------
# STEP 3: Install Elasticsearch
# -----------------------------------------------------------------------------
echo "[3/7] Installing Elasticsearch..."
apt-get install -y elasticsearch

# IMPORTANT: The installer prints a one-time auto-generated password.
# It looks like:
#   The generated password for the elastic built-in superuser is: <PASSWORD>
# COPY THAT PASSWORD NOW and save it. You need it to log into Kibana.
# If you miss it, reset with:
#   /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic

# -----------------------------------------------------------------------------
# STEP 4: Configure Elasticsearch
# -----------------------------------------------------------------------------
echo "[4/7] Configuring Elasticsearch..."

cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak

cat > /etc/elasticsearch/elasticsearch.yml << 'EOF'
cluster.name: soc-lab
node.name: soc-node-1
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node
xpack.security.enabled: true
xpack.security.enrollment.enabled: true
xpack.security.http.ssl.enabled: false
xpack.license.self_generated.type: basic
EOF

# -----------------------------------------------------------------------------
# STEP 5: Install and configure Kibana
# -----------------------------------------------------------------------------
echo "[5/7] Installing Kibana..."
apt-get install -y kibana

cat > /etc/kibana/kibana.yml << 'EOF'
server.port: 5601
server.host: "0.0.0.0"
server.name: "soc-lab-kibana"
elasticsearch.hosts: ["http://localhost:9200"]
EOF

# -----------------------------------------------------------------------------
# STEP 6: Enable and start services
# -----------------------------------------------------------------------------
echo "[6/7] Starting Elasticsearch and Kibana..."

systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch

echo "Waiting 30 seconds for Elasticsearch to initialize..."
sleep 30

systemctl enable kibana
systemctl start kibana

echo "Waiting 20 seconds for Kibana to initialize..."
sleep 20

# -----------------------------------------------------------------------------
# STEP 7: Generate Kibana enrollment token
# -----------------------------------------------------------------------------
echo "[7/7] Generating Kibana enrollment token..."
echo ""
echo "============================================="
echo " INSTALLATION COMPLETE"
echo "============================================="
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Configure Kibana to listen on all interfaces:"
echo "   sudo nano /etc/kibana/kibana.yml"
echo "   Change: #server.host: \"localhost\""
echo "   To:     server.host: \"0.0.0.0\""
echo "   Then:   sudo systemctl restart kibana"
echo ""
echo "2. Get your Kibana enrollment token:"
echo "   /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana"
echo ""
echo "3. Open Chrome on your host machine and go to:"
echo "   http://$(hostname -I | awk '{print $1}'):5601"
echo ""
echo "4. Paste the enrollment token when prompted."
echo ""
echo "5. When asked for a verification code, run:"
echo "   /usr/share/kibana/bin/kibana-verification-code"
echo ""
echo "6. Log in with:"
echo "   Username: elastic"
echo "   Password: [the password printed during Elasticsearch install]"
echo ""
echo "7. Set encryption keys (required for Security rules):"
echo "   /usr/share/kibana/bin/kibana-encryption-keys generate"
echo "   Then add the three keys to /etc/kibana/kibana.yml"
echo "   Then: sudo systemctl restart kibana"
echo ""
echo "============================================="

echo "Elasticsearch status:"
systemctl status elasticsearch --no-pager | grep "Active:"

echo "Kibana status:"
systemctl status kibana --no-pager | grep "Active:"
