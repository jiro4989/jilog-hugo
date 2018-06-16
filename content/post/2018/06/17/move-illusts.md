+++
title = "イラストの配布をDropboxからGitHubReleaseに移行した"
slug = "move-illusts"
date = 2018-06-17T02:47:21+09:00

categories = ["技術"]
tags = ["イラスト", "github release"]

+++

はじめに
--------------------------------------------------------------------------------

イラストの配布場所を移行、自動化、ページ自動生成した話についてぼやきます。
完成したページは[こちら](https://jiro4989.github.io/dist-illust/)。

なぜ移行したか
--------------------------------------------------------------------------------

配布作業とページ更新を自動化したかったからです。

[前ブログ](http://jiroron666.hatenablog.com/archive)で配布を行っていたときはDropboxで配布を行っていました。
一応DropboxはLinux環境でもOSのファイルシステムと同期ができるので、

- イラストを作成(ここまで手作業)
- スクリプトを叩く
  - イラストとREADMEをzip圧縮
  - Dropboxのディレクトリにコピー

という具合にある程度配布を自動化してはいました。
前まではこれで満足していました。

しかし、イラストもプログラムと同様に差分管理したいと考えるようになりました。
そうなると必然的にGitHubのリポジトリでKritaのソースも管理したいですし
どうせならイラストの配布もGitHubReleaseで行いたくなったわけです。

移行にともなった作業
--------------------------------------------------------------------------------

- Dropboxで配布していたときの画像と今GitHubで管理してる画像の統合
- zip圧縮用のスクリプトの作成
- 差分画像から配布用にトリミングして規格を統一するスクリプトの作成
- GitHubReleaseにリリースするタスクの作成
- gh-pagesにイラスト一覧ページを作成するスクリプトの作成

結果
--------------------------------------------------------------------------------

[配布ページ](https://jiro4989.github.io/dist-illust/)が完成しました。
ブログのトップにもILLUSTというリンクを追加しました。

イラストを管理してるリポジトリは[こちら](https://github.com/jiro4989/dist-illust)です。

このブログはGolang製の静的ページジェネレーターのHugoを使用していますが
イラスト一覧ページについては自作ですし、イラストの一覧とダウンロードページの
リンクさえあれば十分と割り切ってHTML生成はめちゃくちゃ手を抜きました。
ページのソースを見ればどれくらい手抜きかわかります。

イラストページ生成スクリプトは下記。
テンプレートエンジンとか使わずbashでHTMLを直書きするという力技。

```bash
#!/bin/bash

set -eu

find dist/ -name *r_stand_001_001.png -exec cp {} img/stand/ \;
find dist/ -name *face_001_001.png | grep -v -e vxace -e _l_ | xargs cp -t img/face/

paste -d " " \
    <(find img/stand/ -type f | sort) \
    <(find img/face/ -type f | sort) \
  | sed -r \
    -e 's@([^ ]+) (.*)$@<div class="actor-block"><div><img src="\1" height="400"></div><div><img src="\2"></div></div>@g' \
    -e 's@(src="img/stand/)(actor[0-9]+)(.*</div>)(</div>)$@\1\2\3<label>\2</label>\4@g' \
  | cat \
    <(echo '<!DOCTYPE html><html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width"><title> 次郎の配布イラスト一覧</title><style>body { font-size: 20px; background-color: #fafbfc; } .actor-block { display: inline-block; text-align: center; border: 2px solid #aaa; margin: 4px; background-color: white; }</style></head><body><h1>次郎の配布イラスト一覧</h1><h2><a href="https://github.com/jiro4989/dist-illust/releases">ダウンロード</a></h2><hr>') \
    - \
    <(echo '<hr><h2><a href="https://github.com/jiro4989/dist-illust/releases">ダウンロード</a></h2><small>&copy; '"$(date +%Y)"' 次郎 <a href="https://twitter.com/jiro_saburomaru">@jiro_saburomaru</a></small></body></html>') > index.html
```

まとめ
--------------------------------------------------------------------------------

絵を描くときに差分用にレイヤを分けて描くようにして
完成したら差分だけをpng出力。

あとはMakefileを使って`make release-all`と叩くだけで
画像の全生成＋GitHubReleaseにリリースしてgh-pagesのイラスト一覧にも画像が追加される
というところまで自動化しました。

あとは過去のブログにこのブログへのリンクを貼って
フォーラムとかのリンクをこっちのブログのリンクに修正すれば移行は完全に完了です。
ここまで長かった...。

とりあえず絵師でイラストの配布を行ってる方は
シェルスクリプトを勉強して配布を自動化すれば
絵を描く作業に集中できるようになるのでオススメです。
