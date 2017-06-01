// Description
//  このhubot-scriptの説明
// 
// Dependencies:
//  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
//
// Configuration:
//  環境設定を書く
//
// Commands:
//  hubot <コマンド(eg. time, youtube)> - <何をするか>
//
// Notes:
//  メモ書き, その他
//
// Author:
//  githubのusernameを書く

var gm = require('googlemaps');

module.exports = function(robot) {
    robot.respond(/gmap (.+)$/i, function(msg){
        console.log(msg.match[1]);
        markers = [{ 'location': msg.match[1] }]
        var output = gm.staticMap(msg.match[1], 14, '1000x800', false, false, 'roadmap', markers);
        msg.send(output);
    });
};