from passlib.context import CryptContext

SALT = "KQUie7sa8opeiyldHWZRnv1RU"
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def verify_pwd(plain_password, hashed_password):
    """
    Verify if the two passwords are the same
    :param plain_password: unhashed password
    :param hashed_password: hashed passoword
    :return: true / false
    """
    return pwd_context.verify(plain_password + SALT, hashed_password)


def hash_pwd(password):
    """
    Hash the provided password with salt
    :param password: password to be hashed
    :return: hashed password
    """
    return pwd_context.hash(password + SALT)
