import os

from flask import Flask, render_template

app = Flask(__name__)


@app.route('/', methods=('GET',))
def index():
    return render_template('index.html',
                           title=os.environ['PAGE_TITLE'])


if __name__ == '__main__':
    app.run('127.0.0.1', 5000, debug=True)
