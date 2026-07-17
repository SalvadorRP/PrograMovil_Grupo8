# !/usr/bin/env python
# -*- coding: utf-8 -*-
from main.application import APP
from main.blueprints import register
from main.middlewares import not_found

register(APP)
APP.register_error_handler(404, not_found)

import logging
import sys
from flask import request

# Configuración de logging para que Render capture todo en la consola
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

@APP.before_request
def log_request_info():
    logger.info(f"--> Endpoint llamado: {request.method} {request.url}")
    if request.is_json:
        logger.info(f"    Payload JSON: {request.get_json(silent=True)}")
    elif request.form:
        logger.info(f"    Payload Form: {request.form.to_dict()}")

@APP.after_request
def log_response_info(response):
    logger.info(f"<-- Respuesta: {response.status}")
    return response

if __name__ == '__main__':
  APP.run(
    debug=True,
    host='0.0.0.0',
    port=5000
  )
