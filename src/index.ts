import { createServer, IncomingMessage, ServerResponse } from 'node:http'
import { EventEmitter } from 'node:events'
import { readFileSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

/** Server port number */
const appPort: number = 3000

/** Current file path */
const pathFilename: string = fileURLToPath(import.meta.url)

/** Directory path of current file */
const pathDirname: string = dirname(pathFilename)

/** Event emitter for handling HTTP requests */
const eventEmitter: EventEmitter = new EventEmitter()

/** Array of active client connections */
const clientConnections: ServerResponse[] = []

/**
 * Handles HTTP request events and broadcasts data to all connected clients.
 * @description Sends the received data to all active SSE client connections.
 * @param data - The data to broadcast to clients
 */
eventEmitter.on('http-request', (data: unknown) => {
  clientConnections.forEach((res: ServerResponse) => {
    res.write('event: http-request\n')
    res.write(`data: ${JSON.stringify(data)}\n\n`)
  })
})

/**
 * HTTP server instance for handling SSE connections and requests.
 * @description Creates a server that handles SSE connections, serves HTML, and processes HTTP requests.
 */
const server: ReturnType<typeof createServer> = createServer(
  /**
   * Handles incoming HTTP requests and routes them appropriately.
   * @param req - The incoming HTTP request
   * @param res - The HTTP response object
   */
  (req: IncomingMessage, res: ServerResponse) => {
    if (req.url === '/sse') {
      res.writeHead(200, {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        Connection: 'keep-alive'
      })
      clientConnections.push(res)
      res.write('data: Connected\n\n')
    } else if (req.url === '/' || req.url === '/index.html') {
      const html: string = readFileSync(join(pathDirname, '../index.html'), 'utf8')
      res.writeHead(200, { 'Content-Type': 'text/html' })
      res.end(html)
    } else {
      let body: string = ''
      req.on('data', (chunk: Buffer) => {
        body += chunk.toString()
      })
      req.on('end', () => {
        eventEmitter.emit('http-request', {
          method: req.method,
          url: req.url,
          headers: req.headers,
          body
        })
        res.writeHead(200, { 'Content-Type': 'application/json' })
        res.end(JSON.stringify({ status: 'OK' }))
      })
    }
  }
)

/**
 * Starts the server and logs the running status.
 * @description Initiates the HTTP server on the specified port and logs the server URL.
 */
server.listen(appPort, () => {
  console.log(`Server running on http://localhost:${appPort}`)
})
