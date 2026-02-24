FROM ruby:3.2.3

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      npm \
      postgresql-client && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの設定（アプリケーション名に変更）
RUN mkdir /kotonoha
WORKDIR /kotonoha

# Gemfile と Gemfile.lock をコピー
COPY Gemfile /kotonoha/Gemfile
COPY Gemfile.lock /kotonoha/Gemfile.lock

# Bundler のインストールと gem のインストール
RUN bundle install

# アプリケーションのコードをコピー
COPY . /kotonoha

# entrypoint.sh をコピーして実行権限を付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# ポートの公開
EXPOSE 3000

# Rails サーバーの起動
CMD ["rails", "server", "-b", "0.0.0.0"]
