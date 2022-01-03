const app = require('express')();
const http = require('http').Server(app);
const io = require('socket.io')(http);

var port = 3000;

// 유저 더미
var firstUser = {
    senderId: "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    displayName: "형석"
};

var secondUser = {
    senderId: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    displayName: "선아"
};

// room 더미
let firstRoom = {
    roomID: "1204304",
    roomTitle: "첫 번 째 방 입니다.",
    createDate: 1.1,
    chats: [
    {
        sender: firstUser,
        messageId: "23523knwrjgkner",
        sentDate: 1.1,
        content: "하이! 반가워"
    },
    {
        sender: secondUser,
        messageId: "sfawegaweg",
        sentDate: 1.2,
        content: "오이! 나도 반가워용"
    }
    ]
}
let secondRoom = {
    roomID: "1204304",
    roomTitle: "두 번 째 방 입니다.",
    createDate: 1.1,
    chats: [
    {
        sender: firstUser,
        messageId: "23523knwrjgkner",
        sentDate: 1.1,
        content: "하이! 반가워"
    },
    {
        sender: secondUser,
        messageId: "sfawegaweg",
        sentDate: 1.2,
        content: "오이! 나도 반가워용"
    }
    ]
}

// room & chat DB
let rooms = [firstRoom, secondRoom];
// 사용자 DB
let users = [firstUser, secondUser];

io.on('connection', (socket) => {
    const req = socket.request;
	const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    console.log('클라이언트 연결 : ', ip, socket.id);

    io.emit('rooms', rooms);

    var currentUser;
    socket.emit('isConnected', currentUser)

    socket.on('fetchUser', (name) => {
        var fetchUser = users.find(function(data){
            return data.displayName == name
        });
        console.log(fetchUser)
        socket.emit('currentUser', fetchUser);
        this.currentUser = fetchUser
    });

    socket.on('disconnect', () => {
        socket.emit('disConnected', currentUser)
        console.log('disconnection socketIO')
    })

    socket.on('createRoom', (room) => {
        rooms.push(room);
        io.emit('rooms', rooms)
        socket.join(room.roomID);
        io.to(room.roomID).emit('msg', `${room.roomTitle} 방이 열렸습니다.`);
    })

    socket.on('chat', (chat, room, user) => {
        var currentRoom = rooms.find(function(data){
            return data.roomID == room.roomID
        });
        currentRoom.chats.push(chat)
        console.log(currentRoom)
        io.to(room.roomID).emit('chat', chat, user, room)
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