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

// room & chat DB
var rooms = [];

// 사용자 DB
var users = [firstUser, secondUser];

// chat DB
var chatDB = [];

io.on('connection', (socket) => {
    const req = socket.request;
	const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    console.log('클라이언트 연결 : ', ip, socket.id);

    // 모든 유저가 입장하면 모든 방의 정보를 받음
    io.emit('rooms', rooms);

    var currentUser;
    socket.emit('isConnected', currentUser)

    // 사용자가 아아디와 패스워드를 입력하면, 
    socket.on('fetchUser', (name) => {
        // DB에서 해당 사용자 정보를 찾아서
        var fetchUser = users.find(function(data){
            return data.displayName == name
        });
        console.log(fetchUser)
        // 해당 사용자에게 유저 정보를 보내줌
        socket.emit('currentUser', fetchUser);
        this.currentUser = fetchUser
    });

    // 사용자가 방을 만드는 경우, 방 정보를 받아서
    socket.on('createRoom', (room) => {
        // DB를 업데이트 -> 클라이언트
        // room.participant.push(currentUser)
        rooms.push(room);
        console.log(rooms)
        // 모든 사용자에게 방이 열렸음을 알림
        io.emit('rooms', rooms)
        // 그리고 방 생성자는 자동으로 입장
        socket.join(room.roomId);
        socket.broadcast.to(room.roomId).emit('msg', `${room.roomTitle} 방이 열렸습니다.`);
    })

    // 사용자가 방에 입장하는 경우, 사용자와 방 정보를 받아서
    socket.on('joinRoom', (room, user) => {
        // DB에서 해당 방의 정보를 업데이트
        var currentRoom = rooms.find(function(data){
            return data.roomId == room.roomId
        });
        currentRoom.participant.push(user)
        console.log(currentRoom)
        // DB에서 이제까지의 채팅 내역 가져오기
        var roomChats = chatDB.filter(function(data){
            return data.roomId == room.roomId
        });
        socket.join(room.roomId);
        socket.emit('roomChats', roomChats)
        socket.broadcast.to(room.roomId).emit('msg', `${user.displayName}님이 입장하셨습니다.`)
    });

    socket.on('leaveRoom', (room, user) => {
        // DB에서 해당 방의 정보를 업데이트
        var currentRoom = rooms.find(function(data){
            return data.roomId == room.roomId
        });
        currentRoom.participant = currentRoom.participant.filter(function(data){
            data.senderId != user.senderId
        })
        console.log(currentRoom)
        socket.leave(room.roomId);
        io.to(room.roomId).emit('msg', `${user.displayName}님이 떠났습니다.`)
    });

    socket.on('chat', (chat, room) => {
        chatDB.push(chat)
        console.log(chatDB)
        io.to(room.roomId).emit('chat', chat)
    })

    socket.on('disconnect', () => {
        socket.emit('disConnected', currentUser)
        console.log('disconnection socketIO')
    })
})

function removeItem(arr, value) {
    var index = arr.indexOf(value);
    if (index > -1) {
      arr.splice(index, 1);
    }
    return arr;
  }

app.get('/', (req, res) => {
    res.send('Hi Swift')
})

http.listen(port, () => {
    console.log(`http Server listen ${port}`)
})