# Description
#  このhubot-scriptの説明
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
#  環境設定を書く
#
# Commands:
#  hubot <コマンド(eg. time, youtube)> - <何をするか>
#
# Notes:
#  メモ書き, その他
#
# Author:
#  githubのusernameを書く


url = require('url')
util = require('util')
querystring = require('querystring')

circleciHost = `process.env.HUBOT_CIRCLECI_HOST? process.env.HUBOT_CIRCLECI_HOST : "circleci.com"`
endpoint = "https://#{circleciHost}/api/v1.1"

checkToken = (msg) ->
  unless process.env.HUBOT_CIRCLECI_TOKEN?
    msg.send 'You need to set HUBOT_CIRCLECI_TOKEN to a valid CircleCI API token'
    return false
  else
    return true

toProject = (project) ->
  if project.indexOf("/") == -1 && process.env.HUBOT_GITHUB_ORG?
    return "#{process.env.HUBOT_GITHUB_ORG}/#{project}"
  else
    return project

toSha = (vcs_revision) ->
  vcs_revision.substring(0,7)

toDisplay = (status) ->
  status[0].toUpperCase() + status.slice(1)

formatBuildStatus = (build) ->
  "#{toDisplay(build.status)} in build #{build.build_num} of #{build.vcs_url} [#{build.branch}/#{toSha(build.vcs_revision)}] #{build.committer_name}: #{build.subject} - #{build.why}"

handleResponse = (msg, handler) ->
  (err, res, body) ->
    if err?
      msg.send "Something went really wrong: #{err}"

    switch res.statusCode
      when 404
        response = JSON.parse(body)
        msg.send "I couldn't find what you were looking for: #{response.message}"
      when 401
        msg.send 'Not authorized.  Did you set HUBOT_CIRCLECI_TOKEN correctly?'
      when 500
        msg.send 'Yikes!  I turned that circle into a square (CircleCI responded 500)' # Don't send body since we'll get HTML back from Circle
      when 200
        response = JSON.parse(body)
        handler response
      else
        msg.send "Hmm.  I don't know how to process that CircleCI response: #{res.statusCode}", body

module.exports = (robot) ->

  robot.respond /circle me (\S*)\s*(\S*)/i, (msg) ->
    unless checkToken(msg)
      return
    project = escape(toProject(msg.match[1]))
    branch = if msg.match[2] then escape(msg.match[2]) else 'master'
    msg.send "#{endpoint}/project/#{project}/tree/#{branch}?circle-token=#{process.env.HUBOT_CIRCLECI_TOKEN}"
    # msg.http("#{endpoint}/project/#{project}/tree/#{branch}?circle-token=#{process.env.HUBOT_CIRCLECI_TOKEN}")
    #   .headers("Accept": "application/json")
    #   .get() handleResponse  msg, (response) ->
    #       if response.length == 0
    #         msg.send "Current status: #{project} [#{branch}]: unknown"
    #       else
    #         currentBuild = response[0]
    #         msg.send "Current status: #{formatBuildStatus(currentBuild)}"

