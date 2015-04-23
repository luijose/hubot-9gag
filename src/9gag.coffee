# Description:
#   Hubot random 9gag image poster
#
# Dependencies:
#   "soupselect"
#   "htmlparser"
#   "jsdom"
#
# Configuration:
#   None
#
# Commands:
#   hubot 9gag
#   hubot 9gag me
#   hubot 9gag jdoe
#
# Author:
#   luijose / EnriqueVidal

Select      = require( "soupselect" ).select
htmlparser  = require "htmlparser"
jsdom       = require "jsdom"

module.exports = (robot)->
  robot.respond /9gag( me)?/i, (msg)->
    send_meme msg, false

send_meme = (msg, location)->
  meme_domain = "http://9gag.com"
  location  ||= "/random"
  if location.substr(0, 4) != "http"
    url = meme_domain + location
  else
    url = location

  msg.http(url)
    .get() (error, response, body)->
      return response_handler "Sorry, something went wrong" if error

      if response.statusCode == 302
        location = response.headers['location']
        return send_meme(msg, location)

      handler = new htmlparser.DefaultHandler((()->), ignoreWhitespace: true )
      parser = new htmlparser.Parser handler
      parser.parseComplete body

      img_title = Select(handler.dom, ".badge-item-title")[0].children[0].raw
      d = jsdom.jsdom().createElement("div")
      d.innerHTML = img_title
      img_title = d.childNodes[0].nodeValue

      img_src = Select(handler.dom, ".badge-animated-container-animated")[0]

      if not img_src
        img_src = Select(handler.dom, ".badge-item-img")[0]
        img_src = img_src.attribs.src
      else
        img_src = img_src.attribs['data-image']

      msg.send img_title, img_src
