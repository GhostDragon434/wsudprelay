# UDP Relay (VLRLY004) — Docker / Railway

Relay WebSocket yang memberi kemampuan UDP ke Cloudflare Worker (`worker/worker_v3.js`),
karena Workers tidak punya socket UDP.

## Isi

- `index.js` — relay (Node 18+, tanpa dependency eksternal)
- `package.json`
- `Dockerfile` — image siap deploy

## Jalankan lokal

```bash
docker build -t udp-relay ./railway
docker run -p 8080:8080 -e REJECT_UDP_443=1 udp-relay
```

## Deploy di Railway (dari GitHub)

1. Push folder ini ke repo GitHub.
2. Railway → New Project → Deploy from GitHub repo.
3. Kalau `Dockerfile` tidak di root repo, set **Root Directory** ke `railway`.
4. Railway mengisi `PORT` otomatis; tambahkan variable `REJECT_UDP_443` bila ingin diubah.
5. Aktifkan domain publik, contoh hasil: `cfudp.up.railway.app`.

## Sambungkan ke Worker

Di dashboard Cloudflare Worker, isi variables:

| Variable | Contoh | Keterangan |
| --- | --- | --- |
| `UDP_RELAY_HOST` | `cfudp.up.railway.app` | host atau URL lengkap relay |
| `UDP_RELAY_PORT` | `443` | opsional |
| `REJECT_UDP_443` | `1` | `1` buang QUIC Initial, `0` izinkan QUIC |
| `DOH_URL` | `https://1.1.1.1/dns-query` | opsional |

Tanpa `UDP_RELAY_HOST`, worker memakai default `cfudp.up.railway.app`.

## Env relay

| Variable | Default | Fungsi |
| --- | --- | --- |
| `PORT` | `8080` | port listen |
| `REJECT_UDP_443` | `1` | buang QUIC Initial pada UDP/443; STUN/TURN/WebRTC tetap diteruskan |
