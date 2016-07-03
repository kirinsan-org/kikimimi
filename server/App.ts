const firebase = require('firebase');
const computeCosineSimilarity = require('compute-cosine-similarity');
const request = require('request-promise');

import {Statistics} from './Statistics'
import {CommandSet} from './CommandSet'
import {Similarity} from './Similarity'
import {Device} from './Device'

firebase.initializeApp({
  serviceAccount: "spajam2016-kirinsan-org-3ceca6c34b02.json",
  databaseURL: "https://spajam2016-kirinsan-org.firebaseio.com/"
});

export class App {
  // private static thresholdSimilarity = 0.7;
  private command: CommandSet;
  private db;

  constructor() {
    this.db = firebase.database();
  }

  exec() {

    // コマンド一覧を取得
    this.db.ref('command').on('value', (snapshot) => {
      this.command = snapshot.val();
    });

    // デバイスの録音データが変更されたときの処理
    this.db.ref('device').on('child_changed', (snapshot) => {

      let device: Device = snapshot.val();
      let commandId = this.getMostSimilarCommandId(device.recordedData);

      // 音声のマッチするコマンドが見つかったら対応するURLを叩く
      if (commandId) {

        console.log('detected command', commandId);

        let command = this.command[commandId];

        // コマンドURLを叩く
        request.post(command.action)
          .then(res => console.log('command executed', res), err => console.error('command failed', err));

        // デバイスへ通知する
        this.db.ref(`device/${snapshot.key}/detectedCommand`).set(commandId);
      }

    });

  }

  /**
   * コマンド一覧の中から最も似ている音声のコマンドを取得する。
   */
  getMostSimilarCommandId(recorded: number[]) {

    // コマンド一覧取得前は何もしない
    if (!this.command) return null;

    // 候補をピックアップ
    let firstCandidates: Similarity[] = [];
    let others: Similarity[] = [];
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

        firstCandidates.push(new Similarity(id, similarity));
      }
    }

    statistics.average = sum / count;

    console.log('statistics', statistics);

    return resultId;
  }
}
