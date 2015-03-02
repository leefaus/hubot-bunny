{Robot, Adapter, TextMessage} = require 'hubot'
amqp                          = require 'amqp'
util                          = require 'util'

class Bunny extends Adapter

  constructor: ->
    super
    @robot.logger.info "Constructor"
    @requestX = @requestQ = null
    @robot.logger.info "Connection Created..."

  send: (envelope, strings...) ->
    @robot.logger.info "Send"

  reply: (envelope, strings...) ->
    @robot.logger.info "Reply"

  connect: ->
    @robot.logger.info "Connect"
    # create the connection
    value = null
    connection = amqp.createConnection({host: "localhost", port: 5672})
    connection.on( "ready", () =>
      connection.exchange("hubot.chatops", {}, (exchange) =>
        connection.queue("hubot.commands", {}, (queue) =>
          queue.bind(exchange, "hubot.commands.#")
          queue.subscribe((message, headers, deliveryInfo) =>
            @robot.logger.info "#{queue.name} received => #{message.data}"
            message = new TextMessage(queue.name, message.data.toString('utf8'), 'messageId')
            @receive message
            )
          )
        )
      )
    connection.on( "error", (err) ->
      console.error "Something Bad Happened #{err.stack}")

  run: ->
    @robot.logger.info "Run"
    @connect()

exports.use = (robot) ->
  new Bunny robot
