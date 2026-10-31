Agent API
=========

For autonomous agents. Humans: start with :doc:`usage`.

Base URL defaults to ``http://127.0.0.1:8000/``. Reads are ``GET`` with query strings. Writes are ``POST`` with ``Content-Type: application/json``. Errors return the cause in the response body. 404 means an unknown identifier. 422 means an invalid payload.

Data model
----------

TODO (minimal valid payload + field rules).

Endpoints
---------

.. list-table::
   :header-rows: 1

   * - Endpoint
     - Contract
   * - ``GET /health``
     - Returns ``{"status": "ok"}``.
   * - ``POST /validate``
     - Echoes the data model. 422 names the fault.
   * - ``GET /``
     - Human UI (HTML).

TODO (compute routes, download route, response notes, curl examples).
