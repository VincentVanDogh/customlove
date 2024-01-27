from dataclasses import dataclass, field
from datetime import datetime
from typing import Any
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from backend.models.message import Message
from backend.responses.notification import Notification, NotificationType
from backend.utils.logger import Logger
from typing import Any, List, Optional

from pydantic import BaseModel, Field, Json


MAX_CONNECTIONS = 10


class Connection:
    timestamp: datetime
    socket: WebSocket

    def __init__(self, _socket):
        self.socket = _socket
        self.timestamp = datetime.now()


class ConnectionManager:
    def __init__(self):
        self.active_connections: dict[int, list[Connection]] = dict()

    async def connect(self, socket: WebSocket, user_id: int):
        await socket.accept()

        # a user can have multiple websocket connections at a time
        if self.active_connections.get(user_id) is None:
            self.active_connections[user_id] = []

        if socket in self.active_connections.get(user_id):
            Logger.warning(f"[ConnectionManager.connect] a socket: {socket} for the user: #{user_id} was already "
                           f"registered")
            return

        if len(self.active_connections.get(user_id)) >= MAX_CONNECTIONS:
            Logger.warning(f"[ConnectionManager.connect] the user: {user_id} has too many connections open. "
                           f"The oldest one will be closed to accommodate for the newest ones.")
            self.active_connections.get(user_id).sort(key=lambda element: element.timestamp)

            # close the socket
            await self.active_connections.get(user_id)[0].socket.close(reason="logout")

            # remove the connection from the connection pool
            self.active_connections.get(user_id).remove(
                self.active_connections.get(user_id)[0]
            )

        self.active_connections.get(user_id).append(Connection(socket))
        Logger.debug(f"[ConnectionManager.connect] added a websocket for a user: {user_id}")

    def disconnect(self, socket: WebSocket, user_id: int):
        if self.active_connections.get(user_id) is None:
            Logger.warning(f"[ConnectionManager.disconnect] user: #{user_id} was not present in the users dictionary")
            return

        try:
            self.active_connections.get(user_id).remove(
                next(element for element in self.active_connections.get(user_id) if element.socket == socket)
            )
        except StopIteration as e:
            Logger.debug(f"[Connection.Manager.disconnect] the socket of user #{user_id} has been deleted before")
            return

        Logger.debug(f"[ConnectionManager.disconnect] disconnected from user: #{user_id}")

    async def send_notification(self, receiver_id: int, notification: Notification):
        Logger.debug(f"[ConnectionManager.send_message] sending notification to {receiver_id}")

        # ignore if the user was not live
        if self.active_connections.get(receiver_id) is None:
            Logger.debug(f"[ConnectionManager.send_message] user #{receiver_id} was not live")
            return

        # send to every the given user's every open socket
        for connection in self.active_connections.get(receiver_id):
            await connection.socket.send_json(notification.json())


connection_manager = ConnectionManager()
