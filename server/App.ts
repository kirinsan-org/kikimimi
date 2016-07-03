const firebase = require('firebase');
const computeCosineSimilarity = require('compute-cosine-similarity');
const request = require('request-promise');

import {Statistics} from './Statistics'
import {CommandSet} from './CommandSet'
import {Device} from './Device'

firebase.initializeApp({
  serviceAccount: "spajam2016-kirinsan-org-3ceca6c34b02.json",
  databaseURL: "https://spajam2016-kirinsan-org.firebaseio.com/"
});

export class App {
  private command: CommandSet;
  private db;
  private activeDeviceIds = {}; // HTTPリクエストを実行中の端末IDを覚える

  constructor() {
    this.db = firebase.database();
  }

  exec() {

    this.db.ref('device').onDisconnect().remove();

    // コマンド一覧を取得
    this.db.ref('command').on('value', (snapshot) => {
      this.command = snapshot.val();
    });

    this.db.ref('device').once('value', (snapshot) => {
      snapshot.forEach(child => {

        let deviceId = child.key;

        this.db.ref(`device/${deviceId}/recordedData`).on('value', (snapshot) => {

          console.log('===== recordedData changed =====');

          let audioData: number[] = snapshot.val();

          // オーディオデータが存在しなければ何もしない
          if (!audioData) return;

          // 対象デバイスのリクエストが実行中なら何もしない
          if (this.activeDeviceIds[deviceId]) return;

          let device: Device = snapshot.val();
          let commandId = this.getMostSimilarCommandId(audioData);

          // 音声のマッチするコマンドが見つかったら対応するURLを叩く
          if (commandId) {

            console.log('detected command', commandId);
            console.log('run on device', deviceId);

            let command = this.command[commandId];
            this.activeDeviceIds[deviceId] = true;

            // コマンドURLを叩く
            request.post(command.action)
              .then(res => {
                console.log('command executed', res);

                // 実行中フラグを削除する
                delete this.activeDeviceIds[deviceId];
              }, err => {
                console.error('command failed', err);

                // 実行中フラグを削除する
                delete this.activeDeviceIds[deviceId];
              });

            // デバイスへ通知する
            console.log(`device/${deviceId}/detectedCommand`, commandId);
            this.db.ref(`device/${deviceId}/detectedCommand`).set(commandId);
          }
        });
      });
    });
  }

  /**
   * コマンド一覧の中から最も似ている音声のコマンドを取得する。
   */
  getMostSimilarCommandId(recorded: number[]) {

    // コマンド一覧取得前は何もしない
    if (!this.command) return null;

    // 候補をピックアップ
    let statistics: Statistics = {
      average: 0,
      max: 0,
      min: 1
    };

    let resultId = null;

    let sum = 0;
    let count = 0;

    for (let id in this.command) {
      let command = this.command[id];

      // 各音声データとの類似度を計算する
      for (let key in command.audioData) {
        let audioData = command.audioData[key];
        let similarity = computeCosineSimilarity(recorded, audioData);
        console.log(`id: ${id}, similarity: ${similarity}`);

        if (statistics.max < similarity) {
          resultId = id;
        }

        // 統計情報
        statistics.max = Math.max(statistics.max, similarity);
        statistics.min = Math.min(statistics.min, similarity);
        sum += similarity;
        count++;
      }
    }

    statistics.average = sum / count;

    console.log('statistics', statistics);

    return resultId;
  }
}
