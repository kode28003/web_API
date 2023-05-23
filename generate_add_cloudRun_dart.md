## cloud run にコードを上げる
参考 : https://zenn.dev/heavenosk/scraps/a557a119bb1ab5



1. 上記の参考サイトにしたがって順にターミナルでコードを実行する
```
mkdir [ファイル名]
```
```
cd [ファイル名]
```
```
dartfn generate helloworld
```

2. コード完成後、以下のコードをターミナルで実行する。
```
gcloud run deploy [ファイル名] --allow-unauthenticated --source=.
```
