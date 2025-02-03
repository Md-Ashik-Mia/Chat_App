// Import dependencies
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const PORT = 3000;
let users = []; // Track connected users

// Serve static files
app.use(express.static(__dirname + '/public'));

// Socket.io logic
io.on('connection', (socket) => {
    console.log('A user connected:', socket.id);

    let username = '';

    // Set username
    socket.on('set username', (name) => {
        username = name;
        users.push(username);
        console.log(`${username} has joined the chat.`);
        socket.broadcast.emit('user joined', `${username} has joined the chat.`);
    });

    // Handle incoming chat messages
    socket.on('chat message', (msg) => {
        const messageData = {
            text: msg.text,
            username: msg.username,
            timestamp: Date.now(),
        };
        io.emit('chat message', messageData);
    });

    // Handle disconnects
    socket.on('disconnect', () => {
        if (username) {
            console.log(`${username} disconnected.`);
            users = users.filter((user) => user !== username);
            io.emit('user left', `${username} has left the chat.`);
        }
    });
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
