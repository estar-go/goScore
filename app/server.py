#encoding=utf-8

import commands
import json
import os
import re
import time
import sys
import random
from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.config['WTF_CSRF_ENABLED'] = False

@app.route('/')
def index():
    return '<h1>Hello, Flask!</h1>'

@app.route('/ai/score', methods=['POST'])
def score():
    sgf = request.form['sgf']
    tmp_file = str(random.randint(100000, 999999)) + '.sgf'
    with open(tmp_file, 'w') as f:
        f.write(sgf)
    output = os.popen("python sgf2gtp.py -f --stdout-only " + tmp_file + " | pachi").read()
    result_line  = re.search('\= [A-Z]\+[0-9]\.[0-9]', output).group()
    result_color = re.search('[A-Z]', result_line).group()
    result_score = re.search('[0-9]\.[0-9]', result_line).group()
    os.remove(tmp_file)
    if result_color == 'B':
        res = {"code": 0, "data": {"b_score": float(result_score), "w_score": 0}}
    elif result_color == 'W':
        res = {"code": 0, "data": {"b_score": 0, "w_score": float(result_score)}}
    else:
        res = {"code": 1}
    return json.dumps(res)

@app.route('/ai/score9', methods=['POST'])
def score9():
    sgf = request.form['sgf']
    tmp_file = str(random.randint(100000, 999999)) + '.sgf'
    with open(tmp_file, 'w') as f:
        f.write(sgf)
    output = os.popen("python sgf2gtp9.py -f --stdout-only " + tmp_file + " | pachi").read()
    result_line  = re.search('\= [A-Z]\+[0-9]\.[0-9]', output).group()
    result_color = re.search('[A-Z]', result_line).group()
    result_score = re.search('[0-9]\.[0-9]', result_line).group()
    os.remove(tmp_file)
    if result_color == 'B':
        res = {"code": 0, "data": {"b_score": float(result_score), "w_score": 0}}
    elif result_color == 'W':
        res = {"code": 0, "data": {"b_score": 0, "w_score": float(result_score)}}
    else:
        res = {"code": 1}
    return json.dumps(res)

if __name__ == '__main__':
    app.config['WTF_CSRF_ENABLED'] = False
    app.run(host='0.0.0.0')
