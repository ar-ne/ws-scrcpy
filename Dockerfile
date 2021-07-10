FROM sacnussem/node-adb:lts-alpine3.12 as build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache alpine-sdk python3 make gcc g++
RUN npm config set registry=http://registry.npm.taobao.org && npm config set scripts-prepend-node-path true

WORKDIR /build
COPY . /build/
RUN npm install && npm run dist:prod

WORKDIR /build/dist
RUN npm install

FROM sacnussem/node-adb:lts-alpine3.12 as runtime

WORKDIR /app
COPY --from=build /build/dist/ /app/

EXPOSE 8000
ENTRYPOINT adb start-server && node server/index.js
