const redis = require('redis')

let redisUrl = process.env.REDIS_URL
console.log(redisUrl)
client = redis.createClient({  url: redisUrl })

client.on('error', (err) => {
    console.error(err);
    process.exit(1)
})

client.set('foo', 'barr', (err, res) => {
    if (err) {
        console.log(err);
        process.exit(1)
    }
    console.log(res);
})

module.exports = client