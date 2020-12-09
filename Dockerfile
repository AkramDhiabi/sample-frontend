# build environment
FROM node as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
COPY yarn.lock /usr/src/app/yarn.lock
RUN yarn install
COPY . /usr/src/app

ENV GENERATE_SOURCEMAP false
RUN yarn build

# production environment
FROM node
RUN yarn global add serve
COPY --from=builder /usr/src/app/build /usr/src/app
EXPOSE 5000
CMD ["serve", "-s", "/usr/src/app"]
