const http = require('http')
const { spawn } = require('child_process')


const server = http.createServer((req, res) => {
  // Ignore everything that isn't a push to a repo (github also sends pings)
  if (req.headers['x-github-event'] === 'push') {
    let body = ''
    req.on('data', d => { body += d })
    req.on('end', () => {
      let data
      try {
        data = JSON.parse(body)
      } catch (e) { console.error(e.message) }
      if (data.ref.startsWith('refs/heads/')) {
        const repositoryName = data.repository.full_name
        const branch = data.ref.slice('refs/heads/'.length)
        console.log(`Push to ${repositoryName}#${branch}`)
        spawn('bash', ['handle-push.sh', repositoryName, branch])
      }
      res.statusCode = 200
      res.end()
    })
  }
})

server.listen(8080, console.error.bind(console))
console.log('Listening for webhook requests')