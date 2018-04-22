+++
title = "立ち絵差分画像をツクールMV・VXACE用の顔画像ファイルに一括トリミングするツール"
slug = "util-tkfm"
date = 2018-04-21T18:20:16+09:00
categories = ["技術"]
tags = ["RPGツクール", "java", "javafx", "gui", "ツール", "配布", "画像"]
+++
はじめに
------------------------------------------------------------------------------

この記事では移行前のブログで紹介していた自作のツールを再紹介しています。  
紹介するツールは「TKoolFacetileMaker」というツクール用の画像トリミングツールです
。

目的
------------------------------------------------------------------------------

複数の立ち絵差分画像をツクール規格に合わせたファイルにまとめる作業を簡略化するこ
とを目的とします。

表情の差分のみといった単純な差分であれば、トリミング位置すべての画像で共通となっ
ているはずです。一枚の画像のトリミング位置を調整すれば、それは他の画像全てに適用
できるはず、という考えを適用しました。

デモ
------------------------------------------------------------------------------

![TKoolFacetileMakerのデモGIF](/img/2018/04/21/util-tkfm/tkfm01.gif)

ご覧の通り位置の一括調整、一括トリミングをマウスだけで簡単に操作できます。キーボ
ードショートカットによって更に素早く操作できます。

ダウンロード
------------------------------------------------------------------------------

https://github.com/jiro4989/TKoolFacetileMaker2/releases

使い方・利用規約・ソースコード
------------------------------------------------------------------------------

純粋なJavaのみでマルチプラットフォームを意識して作成したので、Windows, Mac,
Linuxでも動作するはずです(Macは未確認)。リポジトリは下記。

https://github.com/jiro4989/TKoolFacetileMaker2

余談
------------------------------------------------------------------------------

なんだかんだでこのツールが一番使って頂いてる気がします。ありがたやありがたや...
。実際自分も絵師として一番使用するのがこのツールですし。

もともとは自分が感じていた不満を解消したいと考えて作ったものですが、自分が感じて
いることは同様に他の人も感じている、というのは当たっていたようです。

不満を解消するために始めたツール制作ですが、自分の一番最初の制作ツールがこれです
。自分の原点です。これ自体はJavaFXで作成していますが、これの前進になるSwingのア
プリもあります。デザインが古臭すぎるうえにデザインも壊滅的なんで酷かったです。

ちなみにこのツールだと大量の画像の自動化に向かないので、コマンドラインから実行す
るためのツールを現在Go言語で作成しています。

https://github.com/jiro4989/tkimgutil

ほぼほぼ機能は実装終わってます。トリミング位置の調整だけは原始的なんでそこだけ不
便です。ここだけGUIで設定したら楽なんだろうけどなぁ...。正直他のJavaFXツールで
GUIアプリのメンテのコストの高さに辟易したので、もうこれからはGUIツールは作りたく
ないです。