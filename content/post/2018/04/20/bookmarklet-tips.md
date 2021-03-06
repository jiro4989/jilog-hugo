+++
title = "ブックマークレットを他人に配布するコツ"
date = 2018-04-20T20:44:38+09:00
slug = "bookmarklet-tips"
categories = ["技術"]
tags = ["html", "javascript", "bookmarklet", "tips"]
+++

はじめに
------------------------------------------------------------------------------

ブックマークレットを他人に配布するときのコツを記載しています。

ブックマークレットとは
------------------------------------------------------------------------------

ブラウザ上のブックマークを実行することで即座にJavaScriptのコードを実行する方法。
仕組みは実に単純です。例えばブラウザのURLに下記のコードを入力してEnterします。

```javascript
javascript:console.log("foobar");
```

実行後にF12でコンソールを開くと、foobarとログ出力されていると思います。
これがブックマークレットの基本です。つまり、下記のコメントの箇所に処理を書くだけ
で出来上がりです。

```javascript
javascript:/*ここに処理を書く*/
```

ですが、このまま普通に処理を記述すると変数名が既存のシステムを汚してしまいます。
JavaScriptの無名関数の即時実行を使用することで既存のシステムの値と衝突しないよう
にしましょう。

上記のコードを下記のように改善します。

```javascript
javascript:(function(){/*ここに処理を書く*/})();
```

で、上記のコードを何でもいいのでブックマークを作成してURLの入力欄にコピペしたら
完成です。

ブックマークレットのコツ
------------------------------------------------------------------------------

２つほどあります。下記のとおりです。

- スクリプトの文字数制限に収まるようにするコツ
- 配布する際のコツ

### スクリプトの文字数制限に収まるようにするコツ

スクリプト、というよりブラウザのURLの文字数制限です。Chrome, Firefoxはともに約
30,000文字程度は使えるようです。IEは2000文字程度だとか。IEは毛頭サポートする気が
ないので30,000文字が上限と考えます。文字数制限を少しでもケチるためにコメント文は
書きません。

さらに、少しでも文字数をケチるために要素の取得に`document.querySelector`を使いま
す。`document.querySelector`はCSSセレクタで要素を取得する比較的新しいJSの標準
APIです。jQueryの記法といえば伝わりやすいかもです。

この記法を使う場合、使わない場合を下記に示します。

`document.querySelector`を使わない場合

```javascript
let e1 = document.getElementById("foobar");
let e2 = document.getElementById("hoge");
let e3 = document.getElementById("piyo");
let e4 = document.getElementById("fuga");
```

`document.querySelector`を使う場合

```javascript
let $ = (s) => document.querySelector(s);
let e1 = $("#foobar");
let e2 = $("#hoge");
let e3 = $("#piyo");
let e4 = $("#fuga");
```

文字数制限内に収まるようにするための工夫です。変数名も可能な限り短く。しかもlet
を使います。constは2文字長いので使用しません。半角スペースも可能な限り省略します
。

これらの考慮すべき点を下記にまとめました。

1. コメント文は省略する
1. `document.querySelector`を積極活用する
1. 変数名は短くする
1. 半角スペースは構文が許す限り省略する。

上記を踏まえたブックマークレットとそうでないブックマークレットを作成してみましょ
う。今回サンプルとして作成するブックマークレットは下記の仕様を満たすものとします
。

1. テキストフィールドからテキストを取得する
1. 取得したテキストをconsole.logに出力する
1. 取得したテキストを別のテキストフィールドにセットする
1. 別のテキストフィールドにセットした時間をさらに別のテキストフィールドにセットする。

これらの仕様を満たしたコードを下記に示します。

普通の書き方

```javascript
var nameInput = document.getElementById("nameInput");
var workerInput = document.getElementById("workerInput");
var timeInput = document.getElementById("timeInput");

var name = nameInput.value;
console.log(name);
workerInput.value = name;
timeInput.value = new Date();
```

最適化した書き方

```javascript
let $=(s)=>document.querySelector(s);
let v=$("#nameInput").value;
console.log(v);
$("#workerInput").value=v;
$("#timeInput").value=new Date();
```

| 書き方           | 文字数  |
|:-----------------|:--------|
| 普通の書き方     | 262文字 |
| 最適化した書き方 | 139文字 |

だいぶコンパクトになりました。あとは改行文字を消してブックマークのURLに書き込ん
でやれば完成です。

### 配布する際のコツ

配布する際はhtmlファイルを活用しましょう。前述のコードをhtmlにリンクとして記載し
ておきます。aタグリンクは下記のようになります。  
**ダブルクオートはシングルクオートに置換しました**

```html
<a href="javascript:(function(){let $=(s)=>document.querySelector(s);let v=$('#nameInput').value;console.log(v);$('#workerInput').value=v;$('#timeInput').value=new Date();})();" >
ブックマークレットです
</a>
```

で、使うときはこのリンクを右クリックしてブックマークで保存するだけ。同じhtmlファ
イル内にそういう旨の記載をしておくだけで良いです。

#### 使うユーザによって異なる値が必要になる場合

例えば、ログイン処理が必要になるブックマークレットの場合、ユーザ名やパスワードは
各ユーザ固有です。それを教えてもらうことはセキュリティ的に良くないです。なので、
ブックマークレットをユーザ自身に作ってもらうようにしましょう。

たとえば下記の仕様を満たすブックマークレットを作るとします。

1. ユーザ名を入力する
1. パスワードを入力する
1. ログインボタンをクリックする

この時、ユーザ名とパスワードの値は各ユーザごとに異なりますが、処理自体は全く同じ
はずです。なので、下記のようなコードを作ってhtmlに保存しておきましょう。

```html
<script>
function createBookmarklet() {
  let $ = (s) => document.querySelector(s);
  let name = $("#userNameInput").value;
  let pass = $("#passwordInput").value;
  let script = `
let $=(s)=>document.querySelector(s);
$('#userName').value='${name}';
$('#password').value='${pass}';
$('#login').click();
`;
  script = script.replace(/\n/g, "");
  let bookmarklet = `javascript:(function(){${script}})();`
  $("#bookmarklet").innerHTML += `<a href="${bookmarklet}">ブックマークレット</a><br>`;
}
</script>

<input id="userNameInput" type-"text" /><br>
<input id="passwordInput" type-"text" /><br>
<input type="button" value="作成" onclick="createBookmarklet();" /><br>
<div id="bookmarklet"></div>
```

これでHTMLファイル上でユーザ自身がユーザ名とパスワードを入力してブックマークレッ
トのリンクを生成できるようになりました。あとはこのブックマークレット作成用のHTML
を共有サーバ上にでもおいてWikiなりに周知してあげればきっと使ってくれます。

まとめ
------------------------------------------------------------------------------

ブックマークレットを作成する方法、および作成の際のコツを２つほど紹介しました。

ブックマークレットは既存のシステムに手を加えることなくお手軽に自動化、簡略化する
ための一つの手段です。リンクを使用すれば配布することも簡単なので、ぜひお試しあれ
。

僕もそれの[練習用のページ](https://jiro4989.github.io/html-js-css-training/)を作成しています。気になるかたはご確認ください。

