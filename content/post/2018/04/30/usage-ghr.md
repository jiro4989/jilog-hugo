+++
title = "ghrでGitHubReleaseにリリースしてみる"
slug = "usage-ghr"
date = 2018-04-30T16:08:10+09:00
categories = ["技術"]
tags = ["ghr", "golang", "makefile", "cui", "github", "release", "ツール", "手順"]
+++

はじめに
-------------------------------------------------------------------------------

この記事では[ghr](https://github.com/tcnksm/ghr)というGitHubReleaseへのリリース用のツールの使い方を記載してい
ます。

目的
--------------------------------------------------------------------------------

趣味でアプリを作成して公開したりしていると、ネックになってくるのはリリース作業で
す。最近はもっぱらGo言語でミニマムなCUIツールを作成することが多くて、それをリリ
ースするのを簡略化したいと考えていました。

[以前](http://jiroron666.hatenablog.com/entry/2017/10/08/125842)はgoreleaserとい
うツールを使用していました。こちらでも確かにリリースはできますが、設定ファイルが
結構長くてめんどくさいです。大体過去の自分のリポジトリから設定ファイルをコピーし
てきて修正する感じですが、それでも手間。それにリリースの途中で失敗するとタグが残
ってしまって色々面倒で困っていました。この問題を解消したいと考えました。

ghrとは
--------------------------------------------------------------------------------

端末からGitHubReleaseにリリースできるCUIツールです。goreleaserとの違いは、
goreleaserは各OS向けにクロスビルドをサポートしていて、設定ファイルでOSとアーキテ
クチャを指定して複数ビルドしてファイルをまとめてからリリースしていたのにたいし、
ghrはリリースする機能にのみ絞っている点です。

よって、クロスビルドやREADMEの同封などは自前で用意する必要があります。代わりに、
リリース作業自体は非常に簡単で、下記のコマンド一発でできます。

```bash
ghr TAG PATH
```

めちゃくちゃシンプルです。事前にGITHUB_TOKENの設定はgoreleaserと同様に必要ですが
、設定ファイルを用意しなくてよいという手軽さは素晴らしいです。

実際にリリースしてみる
--------------------------------------------------------------------------------

実際に簡単なコードでリリースしてみましょう。

参考までに今回の記事で紹介している方法と同じ方法でリリースを管理しているリポジト
リは[こちら](https://github.com/jiro4989/tkimgutil)です。

コマンドについてもMakefileにまとめています。

### GITHUB_TOKENの取得

GitHubにログインして下記のURLにアクセスします。

https://github.com/settings/tokens

こちらでGITHUB_TOKENを取得してクリップボードにコピーします。

次に下記のコマンドを端末で実行します。先程コピーしたTOKENも貼り付けます。

```bash
git config --global github.token "{ここにコピーしたTOKENを貼り付け}"
```

### プロジェクトの作成

GitHubになんでもいいので、適当にテスト用にリポジトリを作成します。

### ソースコードを作成

ハローワールド程度のgoのソースを書きます。ここではmain.goというファイル名で保存
したものとします。

### クロスビルド

下記のコマンドを実行します。

```bash
mkdir -p dist
GOOS=linux GOARCH=386 CGO_ENABLED=0 go build -o dist/test-go_linux_386 main.go
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o dist/test-go_linux_amd64 main.go
GOOS=darwin GOARCH=386 CGO_ENABLED=0 go build -o dist/test-go_darwin_386 main.go
GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o dist/test-go_darwin_amd64 main.go
GOOS=windows GOARCH=386 CGO_ENABLED=0 go build -o dist/test-go_windows_386.exe main.go
GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o dist/test-go_windows_amd64.exe main.go
```

dist配下に成果物が6つできていればOKです。

### リリース

下記のコマンドを実行します。
v1.0.0のタグは必要に応じて変更してください。

```bash
ghr v1.0.0 dist/
```

エラーが発生せずに終了すればOKです。
リリースページを確認したらタグ情報とともにリリースされていると思います。

まとめ
--------------------------------------------------------------------------------

ghrというツールを使用して簡単にリリースする方法を確認しました。

今回の例では紹介しませんでしたが、tar.gzにREADMEやCHANGELOGを同梱してリリースす
ることもあると思います。そうなったら、ビルドしたバイナリとREADME, CHANGELOGを圧
縮したtar.gzをリリースするスクリプトが必要になると思います。

僕はMakefileでそれらの手順をまとめて管理しています。上記のリンク先でMakefileにビ
ルドフラグやリリースタスクを管理しているのでよければ参考にしてください。

