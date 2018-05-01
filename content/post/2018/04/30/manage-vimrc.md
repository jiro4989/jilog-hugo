+++
title = "vimrcをファイル分割でガッツリ整理した"
slug = "manage-vimrc"
date = 2018-04-30T19:32:35+09:00
categories = ["技術"]
tags = ["vimrc", "plugin"]
+++

はじめに
--------------------------------------------------------------------------------

この記事ではvimの設定ファイルの整理前、整理後について記載しています。

目的
--------------------------------------------------------------------------------

僕のvimrcは本体が286行で、プラグインを含めると1000行を超えていた。すでに見通しが
だいぶ悪くなっていたのでこれを改善したいと考えた。

プラグインの設定ファイル構成は年初にガッツリ整理して管理しやすくなっていましたが
、デフォルト設定の方が手付かずで散らかっていたので、これを気にしっかり整理しよう
と考えた。

現状把握
--------------------------------------------------------------------------------

現状のvimrcは286行、dotfilesの構成は下記の通り。

    .
    ├── after
    │  └── ftplugin
    │      ├── css.vim
    │      ├── fxml.vim
    │      ├── go.vim
    │      ├── html.vim
    │      ├── java.vim
    │      ├── javascript.vim
    │      ├── kotlin.vim
    │      ├── make.vim
    │      ├── markdown.vim
    │      ├── python.vim
    │      ├── scala.vim
    │      ├── sh.vim
    │      └── xml.vim
    ├── colors
    │   ├── molokai.vim
    │   └── solarized.vim
    ├── dict
    │   ├── java.dict
    │   ├── kotlin.dict
    │   └── scala.dict
    ├── rc
    │   ├── .gvimrc
    │   ├── .vimperatorrc
    │   ├── .vimrc
    │   ├── .vrapperrc
    │   └── plugins
    │       ├── ale.vim
    │       ├── denite.vim
    │       ├── deoplete.vim
    │       ├── emmet-vim.vim
    │       ├── gen_tags.vim
    │       ├── memolist.vim
    │       ├── neocomplete.vim
    │       ├── twitvim.vim
    │       ├── unite.vim
    │       ├── vaffle.vim
    │       ├── vim-airline.vim
    │       ├── vim-alignta.vim
    │       ├── vim-bookmarks.vim
    │       ├── vim-fugitive.vim
    │       ├── vim-gitgutter.vim
    │       ├── vim-go.vim
    │       ├── vim-markdown.vim
    │       ├── vim-slime.vim
    │       ├── vim-table-mode.vim
    │       └── vimfiler.vim
    ├── rplugin.vim
    └── template
        ├── bash.txt
        ├── daylog.md
        ├── go.txt
        ├── java.txt
        └── python.txt

プラグインについては細かく設定ファイルを分けていました。こちらはほとんど手を加え
ない想定ですが、標準オプション周りを管理している.vimrcは抱え過ぎで巨大になってい
るのでこちらを分割しようと思っています。

vimrcの読み込み場所
--------------------------------------------------------------------------------

おもむろにヘルプ(`:h vimrc`)を参考にディレクトリ構成を考えました。

    dotfiles
      +- vim
          +- after
          |   +- ftplugin
          +- color
          +- dict
          +- template
          +- rc
              +- init
              +- plugin

こんな構成にしようと考えました。ディレクトリの役割はそれぞれ下記の通りです。

| ディレクトリ名 | 説明                                            |
|----------------|-------------------------------------------------|
| after          | 拡張子別設定                                    |
| color          | colorschemeファイル                             |
| dict           | 辞書ファイル                                    |
| template       | テンプレートファイル                            |
| rc             | 今回のメインでいじるディレクトリ                |
| rc/init        | vimに標準で含まれる設定のみ記述するディレクトリ |
| rc/plugin      | プラグイン用の設定                              |

次に、現在のvimrcを参考にvimrcを分割します。
init配下に配置するファイルを下記のようにしようと考えました。

| ファイル名   | 説明                                   |
|--------------|----------------------------------------|
| .vimrc       | set rtpするだけ                        |
| basic.vim    | 基本的な設定                           |
| backup.vim   | バックアップディレクトリの設定         |
| ui.vim       | highlightなどの画面表示系              |
| filetype.vim | 拡張子ごとに異なる設定を付与する       |
| keymap.vim   | キーマップ設定                         |
| testing.vim  | 試験運用中の設定。OKならファイルに移す |

実施後
--------------------------------------------------------------------------------

最終的には下記のようになりました。

`tree .vim/ --charset=C | xclip -selection clipboard`

    .vim/
    |-- after
    |   `-- ftplugin
    |       |-- go.vim
    |       |-- java.vim
    |       |-- javascript.vim
    |       |-- kotlin.vim
    |       |-- markdown.vim
    |       |-- python.vim
    |       `-- scala.vim
    |-- colors
    |   |-- molokai.vim
    |   `-- solarized.vim
    |-- dict
    |   |-- java.dict
    |   |-- kotlin.dict
    |   `-- scala.dict
    |-- gvimrc
    |-- rc
    |   |-- init
    |   |   |-- backup.vim
    |   |   |-- basic.vim
    |   |   |-- filetype.vim
    |   |   |-- keymap.vim
    |   |   |-- testing.vim
    |   |   `-- ui.vim
    |   `-- plugin
    |       |-- ale.vim
    |       |-- dein
    |       |   |-- deinrc.vim
    |       |   |-- plugins.toml
    |       |   |-- plugins_lazy.toml
    |       |   `-- plugins_own.toml
    |       |-- denite.vim
    |       |-- deoplete.vim
    |       |-- emmet-vim.vim
    |       |-- gen_tags.vim
    |       |-- memolist.vim
    |       |-- neocomplete.vim
    |       |-- twitvim.vim
    |       |-- unite.vim
    |       |-- vaffle.vim
    |       |-- vim-airline.vim
    |       |-- vim-alignta.vim
    |       |-- vim-bookmarks.vim
    |       |-- vim-fugitive.vim
    |       |-- vim-gitgutter.vim
    |       |-- vim-go.vim
    |       |-- vim-markdown.vim
    |       |-- vim-slime.vim
    |       |-- vim-table-mode.vim
    |       `-- vimfiler.vim
    |-- template
    |   |-- bash.txt
    |   |-- daylog.md
    |   |-- go.txt
    |   |-- java.txt
    |   `-- python.txt
    |-- vimperatorrc
    |-- vimrc
    `-- vrapperrc

vimrcの中身は下記の通り

```vimrc
set encoding=utf-8            " 保存時の文字コード
set fileencoding=utf-8        " 読み込み時の文字コード
set fileencodings=utf-8,cp932 " 読み込み時の文字コード。左が優先
scriptencoding utf-8          " スクリプト内でマルチバイト文字を扱う場合に必要
set fileformats=unix,dos,mac  " 改行コードの自動判別。左が優先
set ambiwidth=double          " □といった文字が崩れる問題の解決

set runtimepath+=~/.vim/colors
set runtimepath+=~/.vim/after/ftplugin

runtime! rc/init/*.vim

" プラグイン設定
source ~/.vim/rc/plugin/dein/deinrc.vim
```

プラグイン設定についてはdeinの設定ファイルで一つ一つ設定しているので、runtime!
ではロードしないようにしています。

まとめ
--------------------------------------------------------------------------------

設定ファイルの見通しを良くするためにvimrcの構成を整理しました。  
リポジトリは[こちら](https://github.com/jiro4989/dotfiles)。

今回の設定整理に際して`~/.vim`配下にvimrcやgvimrcを配置すると設定を読んでくれる
ということを知りました。(というよりruntimepathの通っている箇所においてあれば良く
て`~/.vim`が一番最初にパスの通っている場所)

このことにより、設定ファイルが`$HOME`配下を汚すことがなくなりました。設定ファイ
ルはすべて`~/.vim`配下に集約されました。環境構築のスクリプトも非常に簡単になりま
した。dotfilesとdeinをcloneし、シンボリックシンクを`$HOME/.vim`として作成するだ
けで環境構築終了です。.vimrcや.gvimrcをHOME配下にコピーする設定は削除しました。
快適です！

参考リンク
--------------------------------------------------------------------------------

- [vimrc分割した](http://wakame.hatenablog.jp/entry/2014/09/05/085345)
