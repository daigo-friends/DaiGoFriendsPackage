# DaiGoFriendsPackage
DaiGo-Friends delphi package

[English README](README.md)  
[日本語 README_JP](README_JP.md)

# About
Delphi開発環境で使用できるDaiGo-Friendsのオリジナルコンポーネントです。

現在は次の２つのコンポーネントがあります。  
* StringsHolder  
* TableIniFile

# StringsHolder

これはLinesプロパティのみを持つコンポーネントです。
長い文字列を定数またはリソースにすることは面倒な作業です。 メモコンポーネントはデータモジュールに配置できません。
そこで、このコンポーネントを作成しました。
オブジェクトインスペクタでLinesプロパティを開き、文字列を編集できます。使い方はサンプルプロジェクトを参照してください。

# TableIniFile
データベーステーブルを使用するINIFILEコンポーネントです。
使い方はサンプルプロジェクトを参照してください。

# インストール
1. Delphi IDE でDaiGoFriendsPackageプロジェクトを開く
2. ツール->オプションを開き、ライブラリパスにDaiGoFriendsPackage.dprojのあるフォルダを追加する
3. プロジェクトウィンドウでDaiGoFriendsPackage.bplを右クリックしてビルドする
4. プロジェクトウィンドウでDaiGoFriendsPackage.bplを右クリックしてインストールする

# License
Copyright (c) 2020 daigo-friends  
Released under the MIT license  
https://opensource.org/licenses/mit-license.php  
