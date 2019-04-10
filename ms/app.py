from time import time

from sanic import Sanic
from sanic.response import json

app = Sanic()


@app.route("/")
async def test(request):
    return json({
        "time": time(),
        "version": '3.0'
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
