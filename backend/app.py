# !/usr/bin/env python
# -*- coding: utf-8 -*-
from main.application import APP
from main.blueprints import register
from main.middlewares import not_found

register(APP)
APP.register_error_handler(404, not_found)

import logging
from flask import request

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@APP.before_request
def log_request_info():
    logger.info(f"Endpoint llamado: {request.method} {request.url}")

if __name__ == '__main__':
  APP.run(
    debug=True,
    host='0.0.0.0',
    port=5000
  )
