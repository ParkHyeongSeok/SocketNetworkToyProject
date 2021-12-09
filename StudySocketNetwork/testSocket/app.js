const app = require('express')();

const http = require('http').Server(app);

const io = require('socket.io')(http);

var port = 3000;

// 연결되어 있는 동안 유지될 rooms
let rooms = [];

io.on('connection', (socket) => {
    console.log('connection socketIO')

    socket.emit('isConnected', user)

    io.emit('rooms', rooms)

    socket.on('disconnect', () => {
        socket.emit('isConnected', user)
        console.log('disconnection socketIO')
    })

    socket.on('createRoom', (room) => {
        rooms.push(room);
        io.emit('rooms', rooms)
        socket.join(room.roomID);
        io.to(room.roomID).emit('msg', `${room.roomTitle} 방이 열렸습니다.`);
    })

    socket.on('chat', (chat, room, user) => {
        io.to(room.roomID).emit('chat', chat, user)
    })

    socket.on('joinRoom', (room, user) => {
        socket.join(room.roomID);
        io.to(room.roomID).emit('msg', `${user.nickname}님이 입장하셨습니다.`)
    });

    socket.on('leaveRoom', (room, user) => {
        socket.leave(room.roomID);
        io.to(room.roomID).emit('msg', `${user.nickname}님이 떠났습니다.`)
    });


})

app.get('/', (req, res) => {
    res.send('Hi Swift')
})

http.listen(port, () => {
    console.log(`http Server listen ${port}`)
})