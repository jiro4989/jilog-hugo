+++
title = "ツクールのキャラチップアニメーションの確認用ツール"
slug = "util-tkcas"
date = 2018-04-22T11:19:42+09:00
categories = ["技術"]
tags = ["RPGツクール", "java", "javafx", "gui", "ツール", "配布", "画像", "チャラチップ", "アニメーション"]
+++
はじめに
------------------------------------------------------------------------------

この記事では移行前のブログで紹介していた自作のツールを再紹介しています。  
紹介するツールは「TKoolCharacterAnimationSimulator」というツクール用のアニメーシ
ョン確認ツールです。

目的
------------------------------------------------------------------------------

自分のお気に入りのペイントソフトで絵を描きつつキャラチップのアニメーションを確認
できるようにすることを目的とします。お気に入りのペイントソフト(SAIやクリスタ)な
どとは独立してアニメーションを確認するためだけのツールがあれば目的が達成できると
考えました。

デモ
------------------------------------------------------------------------------

![TKoolCharacterAnimationSimulatorのデモGIF01](/img/2018/04/22/util-tkcas/tkcas01.gif)

![TKoolCharacterAnimationSimulatorのデモGIF02](/img/2018/04/22/util-tkcas/tkcas02.gif)

ご覧の通りペイントソフトの更新をニアリアルタイムに反映しています。最前面表示にも
対応しているので隅っこの方に寄せておいて使うことも可能です。

ダウンロード
------------------------------------------------------------------------------

https://github.com/jiro4989/TKoolCharacterAnimationSimulator/releases

使い方・利用規約・ソースコード
------------------------------------------------------------------------------

純粋なJavaのみでマルチプラットフォームを意識して作成したので、Windows, Mac,
Linuxでも動作するはずです(Macは未確認)。リポジトリは下記。

https://github.com/jiro4989/TKoolCharacterAnimationSimulator

余談
------------------------------------------------------------------------------

まぁ、作ったのはいいものの僕自身はキャラチップを作らないですし、アニメーション制
作もしないので完全作り置きツールです。

この時期は思いついたものを片っ端から実装してたなぁ...。
