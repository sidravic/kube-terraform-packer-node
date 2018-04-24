const Hapi = require('hapi')
const redis = require('./lib/redis_connection.js')

const server=Hapi.server({
    host: '0.0.0.0',
    port: (process.env.PORT || 8000 )
});

// Add the route
server.route({
    method:'GET',
    path:'/hello',
    handler:function(request,h) {

        return'hello world';
    }
});

const init = async() => {

    await server.start()        
    console.log(`Server running on port: ${server.info.port}`)
    pingRedis()
}

process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
})

function pingRedis(){
    redis.ping((err, resp) => {
        console.log(err);
        console.log(resp);
    })
}

init();
