# originally from: https://docs.docker.com/compose/gettingstarted/

import time

import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_ramen_noodles_count():
    retries = 5
    while True:
        try:
            return cache.incr('ramen_noodles')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_ramen_noodles_count()
    return f'There are {count} ramen noodles.\n'
