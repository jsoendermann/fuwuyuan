const Koa = require('koa')
const bodyParser = require('koa-bodyparser')
const Router = require('koa-router')
const helmet = require('koa-helmet')
const compress = require('koa-compress')
const morgan = require('koa-morgan')
const auth = require('koa-basic-auth')

const NODE_ENV = global.process.env.NODE_ENV

const app = new Koa()

const useRouter = router =>
  app.use(router.routes()).use(router.allowedMethods())

if (NODE_ENV === 'production') {
  app.use(morgan('combined'))
} else {
  app.use(morgan('dev'))
}
app.use(helmet())
app.use(compress())
app.use(bodyParser())

app.use(async function(ctx, next) {
  try {
    await next()
  } catch (err) {
    if (401 == err.status) {
      ctx.status = 401
      ctx.set('WWW-Authenticate', 'Basic')
      ctx.set('Authorization', 'Basic')
      ctx.body = 'cant haz that'
    } else {
      throw err
    }
  }
})

app.use(auth({ name: 'pfeife', pass: 'pfeifetest' }))

const router = new Router()

router.get('/', ctx => {
  ctx.body = 'Hello World'
})
router.get('/test', ctx => {
  ctx.body = 'Hello Test'
})

app.use(router.routes())

const PORT = 10085
app.listen(PORT)
console.log(`Listening on ${PORT} (env: ${NODE_ENV})`)
