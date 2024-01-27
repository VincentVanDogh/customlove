import json
from sqlalchemy.engine import Engine
from sqlmodel import create_engine, Session, SQLModel
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlmodel.ext.asyncio.session import AsyncSession


def get_connection_string(is_async: bool = False):
    with open('backend/database.json') as file:
        connection_string = json.load(file)

    prefix = connection_string['prefix']
    if is_async:
        prefix = prefix + "+asyncpg"

    return (f"{prefix}://{connection_string['user']}:{connection_string['password']}@"
            f"{connection_string['address']}/{connection_string['database']}")


def get_engine() -> Engine:
    return create_engine(get_connection_string())


def create_db():
    engine = get_engine()
    SQLModel.metadata.create_all(engine)


def create_session():
    engine = get_engine()
    with Session(engine) as session:
        yield session


async def create_async_session():
    """
    This method is not used by now.
    It has been kept in code, as it might be useful later.
    """
    async_engine = create_async_engine(
        get_connection_string(is_async=True),
        echo=True,
        future=True
    )

    async_session = sessionmaker(
        bind=async_engine, class_=AsyncSession, expire_on_commit=False
    )

    async with async_session() as session:
        yield session
