# UDP relay (VLRLY004) untuk Railway / Docker
FROM node:20-alpine

ENV NODE_ENV=production
WORKDIR /app

# Relay tidak punya dependency eksternal, tapi package.json tetap disalin
# supaya "npm start" & engines terbaca.
COPY package.json ./
RUN npm install --omit=dev --no-audit --no-fund || true

COPY index.js ./

# Railway meng-inject PORT; default 8080 untuk docker run lokal.
ENV PORT=8080
# 1 = buang QUIC Initial di UDP/443 (STUN/TURN tetap lewat). 0 = izinkan QUIC.
ENV REJECT_UDP_443=1

EXPOSE 8080

USER node

CMD ["node", "index.js"]
