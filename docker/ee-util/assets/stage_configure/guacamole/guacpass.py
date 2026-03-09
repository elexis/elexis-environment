import base64
import sys
import random
from hashlib import sha256

# Generate a guacamole database password hash
# see https://stackoverflow.com/a/77730689/905817

ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

def generate_guacmole_password_hash(password, salt):
    """
    password: str
    salt: bytes
    return: hash content bytes
    """
    salt_encode = base64.b16encode(salt)
    passwd = password + salt_encode.decode()
    sts = sha256(passwd.encode())
    return sts.digest()

if __name__ == "__main__":
    _salt=[]
    for i in range(12):
        _salt.append(random.choice(ALPHABET))
    salt = ''.join(_salt).encode('ascii')
    password = generate_guacmole_password_hash(sys.argv[1], salt)
    print(salt.hex().upper()+","+password.hex().upper())