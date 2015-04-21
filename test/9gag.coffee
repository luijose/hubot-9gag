chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe '9gag', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/9gag')(@robot)

  it 'responds to request for random 9gag meme', ->
    expect(@robot.respond).to.have.been.calledWith(/9gag( me)?/i)
