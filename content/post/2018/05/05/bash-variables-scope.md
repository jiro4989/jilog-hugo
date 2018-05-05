+++
title = "Bashの変数のスコープとサブシェル"
slug = "bash-variables-scope"
date = 2018-05-05T11:05:27+09:00

categories = ["技術"]
tags = ["bash", "変数", "スコープ", "サブシェル"]

draft = true
+++

はじめに
--------------------------------------------------------------------------------

bashの変数のスコープについて調べました。

目的
--------------------------------------------------------------------------------

適切な変数のスコープを理解し、扱えるようになること。

ある程度の規模のシェルスクリプトを書く場合にbashの特殊な変数のスコープについて理
解しないといけないと考えたため。

調べた内容
--------------------------------------------------------------------------------

### ローカル変数

bashはトップレベルで宣言した変数はグローバルな変数として処理される。
変数のスコープを制限したい場合は、それらの処理ブロックを関数でラッピングして
local宣言する必要がある。

例えば下記のようなコードである。
local_varは外部から参照できない変数として扱われる。

```bash
#!/bin/bash

set -eu

function local_test() {
  local loval_var=1
  echo $local_var
}

local_test

echo $local_var # ERROR
```

この仕様と可読性などを考慮してmain関数を作成して変数のスコープを制限するという書
き方がある。下記のようなコードである。

```bash
#!/bin/bash

function main() {
  # TODO
  hoge
  fuga
}

function hoge() {

}

function fuga() {

}

main "$@"
```

C言語やPythonで馴染み深いコードのように思う。

### サブシェルとスコープ

[シェルスクリプトを書くときに気をつける9箇条](https://qiita.com/b4b4r07/items/9ea50f9ff94973c99ebe)
という記事を読んでから意識するようになったのだが、サブシェルでは親シェルの変数を
参照できないし、サブシェルで宣言された変数を親シェルは参照できない、というもの。

これは先程のローカル変数宣言をする`local`や`local -r`を付与していようがいまいが
そうなる。

例えば下記のようなコード。

te.sh

```bash
#!/bin/bash

function main() {
  local local_var=local_var
  global_var=global_var

  echo -- te.sh main で実行
  echo local_var is [$local_var]
  echo global_var is [$global_var]
  echo

  echo -- te.sh main から te2.sh を実行
  bash te2.sh
}

echo - te.sh トップレベルで main を実行
main

echo - te.sh トップレベルで実行
echo local_var is [$local_var]
echo global_var is [$global_var]
echo

echo - te.sh トップレベルで te2.sh を実行
bash te2.sh
```

te2.sh

```bash
#!/bin/bash

echo --- te2.sh で実行
echo local_var is [$local_var]
echo global_var is [$global_var]
echo
```

これで`bash te.sh`を実行すると実行結果は下記のようになる。

```bash
- te.sh トップレベルで main を実行
-- te.sh main で実行
local_var is [local_var]
global_var is [global_var]

-- te.sh main から te2.sh を実行
--- te2.sh で実行
local_var is []
global_var is []

- te.sh トップレベルで実行
local_var is []
global_var is [global_var]

- te.sh トップレベルで te2.sh を実行
--- te2.sh で実行
local_var is []
global_var is []

```

関数内で宣言した`global_var`はトップレベルからなら参照できているが、サブシェルか
らはどちらの変数も参照できていないことがわかる。

ではサブシェルでも参照したいグローバルな変数を定義したい場合はどうするか、という
と`export`で環境変数として定義する。

ローカル変数、グローバル変数両方をexportしてみる。
あくまでテストなんでローカル変数も公開してみる。ホントは良くないが。

```bash
#!/bin/bash

function main() {
  local local_var=local_var
  global_var=global_var

  export local_var
  export global_var

  echo -- te.sh main で実行
  echo local_var is [$local_var]
  echo global_var is [$global_var]
  echo

  echo -- te.sh main から te2.sh を実行
  bash te2.sh
}

echo - te.sh トップレベルで main を実行
main

echo - te.sh トップレベルで実行
echo local_var is [$local_var]
echo global_var is [$global_var]
echo

echo - te.sh トップレベルで te2.sh を実行
bash te2.sh
```

実行結果

```bash
- te.sh トップレベルで main を実行
-- te.sh main で実行
local_var is [local_var]
global_var is [global_var]

-- te.sh main から te2.sh を実行
--- te2.sh で実行
local_var is [local_var]
global_var is [global_var]

- te.sh トップレベルで実行
local_var is []
global_var is [global_var]

- te.sh トップレベルで te2.sh を実行
--- te2.sh で実行
local_var is []
global_var is [global_var]

```

無事サブシェルから参照できていることが確認できた。

面白いのは、exportしたローカル変数はサブシェルからは参照できるが、同じシェル内か
らは参照できないことだ。今回の試験で初めて気づけた事象だ。テストしてよかった。

まとめ
--------------------------------------------------------------------------------

今回の試験結果をテーブルにまとめた。

![参照可否](/img/2018/05/05/bash-variables-scope/scope_all.png)

前述のlocal変数は同じシェル内の関数外から参照できないが、サブシェルからは参照で
きる、というのは下記の部分。

![参照可否(export指定あり)](/img/2018/05/05/bash-variables-scope/scope_export.png)

export指定したら環境変数に設定されるのだから関数外からも使えそうな意識でいたので
この結果は予想外だった。まぁ、local指定の変数をexportするような使い方を普通はし
ないはずなので、あまり気にしなくて良いような気もする。
