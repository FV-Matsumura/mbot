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

module.exports = (robot) ->

  robot.hear /HELLO$/i, (msg) ->
    msg.send "hello!"

  robot.respond /who are you/i, (msg) ->
    msg.reply "I'm hubot!"

  robot.respond /what is this (.*)/i, (msg) ->
    msg.send "This is #{msg.match[1]}"