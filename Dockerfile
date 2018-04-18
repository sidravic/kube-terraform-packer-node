FROM node:8.11.1

RUN mkdir -p /chomeshvan

WORKDIR /chomeshvan

COPY package.json /chomeshvan/.

RUN npm install 

COPY . /chomeshvan/

EXPOSE 8000

CMD ["node", "app.js"]




