var irc = require('xdcc').irc, ProgressBar = require('progress'), progress, arg = process.argv;
var user = 'dl_' + Math.random().toString(36).substr(2), bar = '   [:bar] :percent, :etas remaining';
var client = new irc.Client(arg[2], user, { channels: [ '#' + arg[3] ], userName: user, realName: user });
var last = 0, handle = received => { progress.tick(received - last); last = received; };

client.on('join', (channel, nick) => nick == user && client.getXdcc(arg[4], 'xdcc send #' + arg[5], arg[6]));
client.on('xdcc-connect', meta => progress = new ProgressBar(bar, {incomplete: ' ', total: meta.length, width: 40}));
client.on('xdcc-data', handle).on('xdcc-end', r => { handle(r); process.exit(); } ).on('error', m => console.error(m));
