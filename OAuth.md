# OAuth2.0

## OAuth2.0とは
→ クライアントアプリと自分のアプリをやり取りする際にユーザーを承認する役割である。承認には、**アクセストークン**を使用する


一定時間ごとにアクセストークンは、期限切れになる。

固定のリフレッシュトークンを使用して、定期的にアクセストークンを取得できる。

GCPの認証情報から、OAuth 2.0 クライアントIDを作成する

## OAuth2.0の手順
### 1. 認可コードを取得する。
```
https://accounts.google.com/o/oauth2/v2/auth?
scope=**[必要なスコープ]**
&access_type=offline
&include_granted_scope=true
&response_type=code
&redirect_uri=https://console.cloud.google.com/apis/library?project=**[Firebaseのプロジェクト名]**
&client_id=**[クライアントid]**
```

### 2.  1 で遷移した画面のURLには、**code=@@@@@@** とあるので、その部分をコピーする。

それが**認可コード**となる

### 3.  2 の認可コード@@@@@@をUriにデコードする。

[Uriのデコード - サイト ](https://tech-unlimited.com/urlencode.html)


### 4. **リフレッシュトークン**の取得
→ FlutterFlow上でAPI callしてリフレッシュトークンを取得する。
```
POST https://www.googleapis.com/oauth2/v4/token
{
  "code": **[デコードした認可コード]**,
  "client_id": **[クライアントId]**,
  "client_secret": **[シークレットId]**,
  "redirect_uri": "https://console.cloud.google.com/apis/library?project=**[プロジェクト名]** ",
  "grant_type" : "authorization_code",
  "access_type": "offline",
  "approval_prompt" : "force"
}
```
 
- "approval_prompt" : "force" を入れることが重要！！
 
**リフレッシュトークンは、必ず保存しておく**

### 5. リフレッシュトークンから **アクセストークン** を取得する
```
POST https://www.googleapis.com/oauth2/v4/token
{
  "refresh_token": **[リフレッシュトークン]**,
  "client_id": **[クライアントId]**,
  "client_secret": **[シークレットId]**,
  "redirect_uri": "https://console.cloud.google.com/apis/library?project=**[プロジェクト名]**",
  "grant_type" : "refresh_token",
  "access_type": "offline",
  "approval_prompt" : "force"
}
```

## 参考サイト
- [OAuth 2.0 を使用してGoogle API にアクセスする方法](https://blog.shinonome.io/google-api/)
- [OAuth2.0を使って認証を通す](https://www.y-hakopro.com/entry/google_oauth_api)
- [Not receiving Google OAuth refresh token](https://stackoverflow.com/questions/10827920/not-receiving-google-oauth-refresh-token)
