import json
import os
import os.path
from sys import platform

import psycopg2
import pytest
from fastapi.testclient import TestClient
from fastapi_pagination import add_pagination
from sqlmodel import Session, SQLModel, create_engine
from sqlmodel.pool import StaticPool

from backend.main import app
from backend.repository.repository import create_session


@pytest.fixture(name="session")
def session_fixture():
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    SQLModel.metadata.create_all(engine)
    with Session(engine) as session:
        yield session

    engine.dispose()


@pytest.fixture(name="client")
def client_fixture(session: Session):
    def create_session_override():
        return session

    app.dependency_overrides[create_session] = create_session_override
    add_pagination(app)
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()


@pytest.fixture(name="postgis_session")
def postgis_session_fixture():
    file_path = 'backend/database.json'

    if 'win32' in platform:
        current_path = os.getcwd()
        file_path = os.path.abspath(os.path.join(get_dir(current_path), 'database.json'))

    with open(file_path) as file:
        connection_string = json.load(file)

    prefix = connection_string['prefix']
    url = (f"{prefix}://{connection_string['user']}:{connection_string['password']}@"
           f"{connection_string['address']}")

    # create the test database
    execute_db_operation(f"{url}/postgres", "DROP DATABASE IF EXISTS test;")
    execute_db_operation(f"{url}/postgres", "CREATE DATABASE test")
    execute_db_operation(f"{url}/test", "CREATE EXTENSION postgis;")

    engine = create_engine(f"{url}/test")
    SQLModel.metadata.create_all(engine)
    with Session(engine) as session:
        yield session

    engine.dispose()

    # destroy the test database
    execute_db_operation(f"{url}/postgres", "DROP DATABASE test")


@pytest.fixture(name="postgis_client")
def postgis_client_fixture(postgis_session: Session):
    def create_session_override():
        return postgis_session

    app.dependency_overrides[create_session] = create_session_override
    add_pagination(app)
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()


def execute_db_operation(url: str, cmd: str):
    conn = psycopg2.connect(url)
    conn.autocommit = True
    cursor = conn.cursor()
    cursor.execute(cmd)
    conn.close()


def get_dir(path):
    index_of_third_last_backslash = path.rfind('\\', 0, path.rfind('\\', 0, path.rfind('\\')))
    if index_of_third_last_backslash != -1:
        truncated_path = path[:index_of_third_last_backslash]
        return truncated_path
