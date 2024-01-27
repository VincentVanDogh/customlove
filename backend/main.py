import argparse
import uvicorn
from fastapi import FastAPI
from fastapi_pagination import add_pagination
from starlette.middleware.cors import CORSMiddleware
from backend.datagenerator.data_generator import DataGenerator
from backend.repository.repository import create_db, get_engine
from backend.routers import message, conversation
from backend.routers import user, language, preference, rating, swipe_status, interest, gender_identity, image, profile_picture

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

add_pagination(app)
app.include_router(user.router)
app.include_router(language.router)
app.include_router(preference.router)
app.include_router(rating.router)
app.include_router(swipe_status.router)
app.include_router(interest.router)
app.include_router(gender_identity.router)
app.include_router(message.router)
app.include_router(conversation.router)
app.include_router(image.router)
app.include_router(profile_picture.router)


@app.on_event("startup")
def on_startup():
    create_db()
    data_generator: DataGenerator = DataGenerator(get_engine())
    data_generator.generate_data()


@app.get("/health")
def read_root():
    """
    kubernetes liveness probe
    """
    return {"status": "application_alive"}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog='INSO_06',
        description='INSO_06 project backend')
    parser.add_argument('--production', action='store_true')
    parser.add_argument('--proxy-headers', action='store_true')
    parser.add_argument('--reload', action='store_true')
    parser.add_argument('--host', default="127.0.0.1")
    parser.add_argument('--port', default=8000)
    parser.add_argument('--root-path', default="")
    args = parser.parse_args()
    uvicorn.run("backend.main:app", host=args.host, port=int(args.port), root_path=args.root_path, proxy_headers=args.proxy_headers,
                reload=args.reload)
