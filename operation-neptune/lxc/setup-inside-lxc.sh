#!/bin/bash
# Setup Operation Neptune inside LXC container
# Run this script inside the LXC container

set -e

echo "=== Setting up Operation Neptune in LXC ==="
echo ""

# Update system
echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install required packages
echo "Installing nginx and tools..."
apt-get install -y \
    nginx \
    curl \
    unzip \
    wget

# Create web directory
WEB_DIR="/var/www/operation-neptune"
mkdir -p "$WEB_DIR/game"

# Create the index.html
echo "Creating web interface..."
cat > "$WEB_DIR/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Operation Neptune - Self-Hosted DOS Game</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background-color: #1a1a2e;
            color: #eee;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        header {
            text-align: center;
            padding: 20px;
            background: linear-gradient(135deg, #16213e 0%, #0f3460 100%);
            width: 100%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
        }
        h1 {
            color: #00d9ff;
            text-shadow: 0 0 10px rgba(0, 217, 255, 0.5);
            margin-bottom: 10px;
        }
        .subtitle { color: #aaa; font-size: 0.9em; }
        main {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            width: 100%;
            max-width: 1000px;
        }
        #dos-container {
            width: 100%;
            max-width: 800px;
            aspect-ratio: 4/3;
            background-color: #000;
            border: 3px solid #0f3460;
            border-radius: 8px;
            box-shadow: 0 0 30px rgba(0, 217, 255, 0.2);
            overflow: hidden;
        }
        #dos { width: 100%; height: 100%; }
        .controls {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: center;
        }
        button {
            background: linear-gradient(135deg, #0f3460 0%, #16213e 100%);
            color: #00d9ff;
            border: 2px solid #00d9ff;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            transition: all 0.3s ease;
        }
        button:hover {
            background: #00d9ff;
            color: #1a1a2e;
            box-shadow: 0 0 15px rgba(0, 217, 255, 0.5);
        }
        .instructions {
            margin-top: 30px;
            padding: 20px;
            background-color: #16213e;
            border-radius: 8px;
            max-width: 800px;
            width: 100%;
        }
        .instructions h2 { color: #00d9ff; margin-bottom: 15px; }
        .instructions ul { list-style-position: inside; line-height: 1.8; }
        .loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #00d9ff;
        }
        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #16213e;
            border-top-color: #00d9ff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 20px;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        footer {
            text-align: center;
            padding: 15px;
            background-color: #16213e;
            width: 100%;
            color: #666;
            font-size: 0.8em;
        }
        footer a { color: #00d9ff; text-decoration: none; }
    </style>
</head>
<body>
    <header>
        <h1>Operation Neptune</h1>
        <p class="subtitle">Super Solvers Educational Game (1991) - The Learning Company</p>
    </header>
    <main>
        <div id="dos-container">
            <div id="dos">
                <div class="loading">
                    <div class="spinner"></div>
                    <p>Loading emulator...</p>
                </div>
            </div>
        </div>
        <div class="controls">
            <button onclick="toggleFullscreen()">Fullscreen</button>
            <button onclick="restartGame()">Restart</button>
        </div>
        <div class="instructions">
            <h2>Controls</h2>
            <ul>
                <li><strong>Arrow Keys</strong> - Move your submarine</li>
                <li><strong>Spacebar</strong> - Select / Confirm</li>
                <li><strong>Enter</strong> - Confirm selection</li>
                <li><strong>Esc</strong> - Menu / Cancel</li>
                <li><strong>Click on the game</strong> to capture mouse and keyboard</li>
            </ul>
        </div>
    </main>
    <footer>
        <p>Powered by <a href="https://js-dos.com/" target="_blank">js-dos</a> |
        Game from <a href="https://archive.org/details/neptune_202204" target="_blank">Internet Archive</a></p>
    </footer>
    <script src="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.js"></script>
    <link rel="stylesheet" href="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.css">
    <script>
        let ci = null;
        Dos(document.getElementById("dos"), {
            url: "game/neptune.jsdos",
            autoStart: true,
        }).then((instance) => {
            ci = instance;
        }).catch((error) => {
            document.getElementById("dos").innerHTML = '<div class="loading"><p style="color: #ff6b6b;">Failed to load game.</p><p style="margin-top: 10px; font-size: 0.9em;">Make sure neptune.jsdos exists in the game/ folder.</p></div>';
        });
        function toggleFullscreen() {
            const container = document.getElementById("dos-container");
            if (!document.fullscreenElement) {
                container.requestFullscreen().catch(err => console.error(err));
            } else {
                document.exitFullscreen();
            }
        }
        function restartGame() { location.reload(); }
    </script>
</body>
</html>
HTMLEOF

# Configure nginx
echo "Configuring nginx..."
cat > /etc/nginx/sites-available/operation-neptune << 'NGINXEOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    root /var/www/operation-neptune;
    index index.html;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/wasm;

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|wasm)$ {
        expires 7d;
        add_header Cache-Control "public, immutable";
    }

    location /game/ {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods "GET, OPTIONS";
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
NGINXEOF

# Enable site
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/operation-neptune /etc/nginx/sites-enabled/

# Test and reload nginx
nginx -t
systemctl enable nginx
systemctl restart nginx

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Download the game from Archive.org:"
echo "   https://archive.org/details/msdos_Super_Solvers_Operation_Neptune_1990"
echo ""
echo "2. Create a .jsdos bundle and place it at:"
echo "   $WEB_DIR/game/neptune.jsdos"
echo ""
echo "3. Access the game at:"
echo "   http://$(hostname -I | awk '{print $1}')"
echo ""
