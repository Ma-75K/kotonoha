# ことのは

## サービス概要
忙しい子育ての中で、
「だっこ」「ぶーぶ」「できた！」といった
今しか聞けない言葉を前に、
「この言葉、忘れたくない」と思いながらも、
記録できずに過ぎてしまう瞬間があります。
「ことのは」は、子どもの声と言葉をワンタップで残し、
未来の宝物に変える、子育て向け記録アプリです。


## サービスURL
https://kotonoha-48o0.onrender.com/


## ターゲットユーザー
- 0～5歳の子どもを育てている保護者
- 子どもの言葉や成長を大切に残したい方
- 忙しくても手軽に記録したい方
　

## 解決したい課題
- 忙しくて記録する余裕がない
- 残したい気持ちはあるのに残せていない
- 思いついた瞬間に操作する余裕がない
- 日記形式は手間がかかり継続できない


## 提供する価値
- 【今すぐ残せる】ワンタップで記録できる
- 【そのまま残せる】声・言葉・雰囲気を含めて保存
- 【振り返れる】「一年前の今日」で思い出を再発見


## MVPで検証したいこと
- ワンタップで録音というシンプルな導線は継続利用につながるか
- 音声で記録する体験に価値を感じてもらえるか
- 振り返り体験がユーザーにとって魅力的か


## 主な機能

### 基本機能
- ユーザー登録/ログイン
- 子ども情報の登録・管理
- 音声録音機能（ワンタップ）
### 記録機能
- 録音の保存・再生
- タイトル/ひとこと編集
- 録音の削除
### 体験機能
- 最近の記録表示
「一年前の今日」の表示


## 工夫した点
- 「録音」ではなく「ことば」を主役にした設計
- ワンタップで完結するシンプルな導線
- 読みやすさを重視した余白・行間設計
- 感情を損なわないやさしい文言設計


## なぜこのサービスを作ったか
子どもの成長の中で、ふとした瞬間に心に残る言葉があります。

「この言葉、忘れたくない」

そう思っても、日常の忙しさの中で記録できず、
時間が経つとその声や言い方を思い出せなくなることがありました。

写真や動画は残る一方で、
「言葉そのもの」を残す手段は少ないと感じました。

そこで、
完璧な記録ではなくてもいい、
思い立った瞬間に子どもの「声」と「言葉」をそのまま残せるサービスを作りたいと考えました。


## 既存サービスとの差別化

### 育児管理アプリ
成長記録や健康管理など入力項目が多く、「今この瞬間」を残すには操作の手間がかかります。

「ことのは」は、記録項目を「子どもの言葉と声」に絞り、
アプリを開いてすぐにワンタップで記録できる設計にしています。

### メモ・音声メモアプリ

用途が自由なぶん、後から見返した際に子どもの言葉が他のメモに埋もれてしまいます。

「ことのは」では、子どもの言葉に特化して整理するため、後から思い出として振り返りやすくしています。

### 写真アプリ

写真が主体になるため、言葉そのものの記憶が残りにくい傾向があります。

「ことのは」は、言葉と声を中心に設計することで、
写真では残しきれない成長の瞬間を大切に保存します。


「ことのは」は、多機能な育児アプリではなく、
「今しか聞けない言葉を、その瞬間に迷わず残す」ための記録アプリです。


## 技術スタック

- Ruby on Rails
- PostgreSQL
- ActiveStorage
- JavaScript（MediaRecorder API）
- Hotwire（Turbo）


## 今後の展望
- 音声の自動文字起こし
- 家族共有機能
- お気に入り機能
- タグ付け・検索機能
- 思い出の自動まとめ（AI）


## 画面遷移図
https://www.figma.com/design/7Zx2RbhwxDdRNnZVny8ov1/%E5%8D%92%E6%A5%AD%E5%88%B6%E4%BD%9C%E3%80%90%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3%E3%80%91?node-id=0-1&t=yPohb3fnXBDzClK7-1

※実装を通じて一部変更があります


## ER図
[![Image from Gyazo](https://i.gyazo.com/607ef6b26071dd7fcab7c25c31d8019a.png)](https://gyazo.com/607ef6b26071dd7fcab7c25c31d8019a)


## 環境構築

### 前提条件
- Docker Desktop がインストールされていること
- Git がインストールされていること
- Docker Desktop が起動していること

### セットアップ手順
1. リポジトリをクローン
```bash
git clone https://github.com/Ma-75K/kotonoha.git
cd kotonoha
```

2. Dockerコンテナをビルド
`docker compose build`

3. データベースをセットアップ
```bash
# データベースを作成
docker compose run --rm web rails db:create
docker compose run --rm web rails db:migrate
docker compose run --rm web rails db:seed
```

4. アプリケーションの起動
`docker compose up`

5. ブラウザでアクセス
https://localhost:3000


## よく使うコマンド

### コンテナの起動・停止
```bash
# コンテナの起動
docker compose up

# バックグラウンドで起動
docker compose up -d

# コンテナの停止
docker compose down

# コンテナとボリュームを削除（データベースも削除される）
docker compose down -v
```

### データベース関連
```bash
# マイグレーションの実行
docker compose exec web rails db:migrate

# データベースのリセット
docker compose exec web rails db:reset

# Railsコンソールの起動
docker compose exec web rails console

# データベースを再作成
docker compose exec web rails db:drop db:create db:migrate
```

### その他
```bash
# テスト実行
docker compose exec web rspec

# Gemのインストール
docker compose exec web bundle install

# コンテナ内でbashを起動
docker compose exec web bash

# ログを確認
docker compose logs

# 特定のサービスのログを確認
docker compose logs web
docker compose logs db

# コンテナの状態を確認
docker compose ps
```

## トラブルシューティング

### 1. ポートが既に使用されている
**エラーメッセージ**
`Bind for 0.0.0.0:3000 failed: port is already allocated`

**原因**
他のアプリケーションがポート3000を使用している

**対処法**
```bash
# 使用中のプロセスを確認
lsof -i :3000

# プロセスを終了（PIDは上記コマンドで確認）
kill -9 <PID>

# または、コンテナを停止してから再起動
docker compose down
docker compose up
```

### 2. データベースに接続できない
**エラーメッセージ**
`could not connect to server: Connection refused`

**原因**
- データベースコンテナが起動していない
- データベースが作成されていない

**対処法**
```bash
# コンテナを再起動
docker compose down
docker compose up -d

# データベースを作成
docker compose exec web rails db:create
```

### 3. Gemがインストールされていない
**エラーメッセージ**
`cannot load such file -- <gem名>`

**原因**
- Gemfileを変更したが、bundle installを実行していない

**対処法**
```bash
# Gemを再インストール
docker compose exec web bundle install

# コンテナを再ビルド（キャッシュを使わない）
docker compose down
docker compose build --no-cache
docker compose up -d
```

### 4. マイグレーションファイルが実行されていない
**エラーメッセージ**
`Migrations are pending. To resolve this issue, run: bin/rails db:migrate RAILS_ENV=development`

**原因**
マイグレーションファイルを作成したが、実行していない

**対処法**
```bash
# マイグレーションファイルを実行
docker compose exec web rails db:migrate
```

### 5. コンテナが起動しない
**エラーメッセージ**
`(様々なエラーメッセージ)`

**原因**
- docker-compose.yml の設定ミス
- Dockerfile の設定ミス
- ポートの競合

**対処法**
```bash
# ログを確認
docker compose logs

# 特定のサービスのログを確認
docker compose logs web
docker compose logs db

# コンテナの状態を確認
docker compose ps

# コンテナを完全に削除して再ビルド
docker compose down -v
docker compose build --no-cache
docker compose up
```

### 6. データベースのデータが消えた
**原因**
- `docker compose down -v` を実行した
- ボリュームが削除された

**対処法**
```bash
# データベースを再作成
docker compose exec web rails db:create
docker compose exec web rails db:migrate
docker compose exec web rails db:seed
```
**予防策**
- データを残したい場合は`docker compose down -v`を使わない
- 定期的にバックアップをとる

### 7. 音声録音ができない
**原因**
- ブラウザのマイク権限が許可されていない
- HTTPSでアクセスしていない

**対処法**
- ブラウザの設定でマイク権限を許可
- HTTPSでアクセスする

### 8. 「一年前の今日」が表示されない
**原因**
- 一年前のデータが存在しない

**対処法**
- テストデータを作成する
```bash
docker compose exec web rails console
# コンソール内で過去のデータを作成
```
