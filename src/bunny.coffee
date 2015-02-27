{Robot, Adapter, TextMessage} = require 'hubot'
amqp                          = require 'amqp'

class Bunny extends Adapter

  constructor: ->
    super
    @robot.logger.info "Constructor"

  send: (envelope, strings...) ->
    @robot.logger.info "Send"

  reply: (envelope, strings...) ->
    @robot.logger.info "Reply"

  connect: ->
    @robot.logger.info "Connect"

  run: ->
    @robot.logger.info "Run"

exports.use = (robot) ->
  new Bunny robot
