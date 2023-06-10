const crypto = require('crypto');
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);

var keys = []

function addUser(key, licensed_to, license_expires, allowed_games) {
  const object = {
        key: key,
        whitelisted: true,
        licensed_to: licensed_to,
        license_expires: license_expires,
        allowed_games: allowed_games,
  };
  keys.push(object);
}

addUser("secretkey123", "Builderman", 1737829152, [4483381587, 6875896837, 301549746]);
addUser("privatekey77", "RobloxGuy192", 1647829152, [4483381587]);

app.get('/authenticate', (req, res) => {
  const { key } = req.query;
  if(key != null) {
    const query = keys.find(element => crypto.createHash('sha256').update(element.key).digest('hex') == key);
    if(query != null) {
      delete query.key
      res.status(200).json(query);
    } else {
      res.status(200).json({
        whitelisted: false
      });
    }
  }
});

server.listen(1337, () => {
  console.log('Server started, listening on port 80!');
});

