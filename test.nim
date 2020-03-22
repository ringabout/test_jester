import jester

settings:
  port = Port(8080)
  bindAddr = "127.0.0.1"
  staticDir = "public"

routes:
  get "/":
    resp "ok"
