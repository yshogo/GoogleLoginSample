* 詳細は下記に書いた記事に
http://jesus9387.hatenablog.com/entry/2017/09/08/124052


## Firebaseを使ったGoogleログインサンプル

ハマったのでメモとして残しておきます。
前提としてFirebaseの設定が終わっているものとします。

## AuthenticationでGoogleログインを許可する

- Firebaseの管理画面を開き「ログイン方法」タブからGoogleログインを有効にする

http://jesus9387.hatenablog.com/entry/2017/09/08/124052

## インストール

- Podfileを開き下記を追加

```
pod 'Firebase/Auth'
pod 'GoogleSignIn'
```

- ```pod install``` を実行

## REVERSED_CLIENT_IDを設定

### Info > URL Typeに、以下の２つのエントリを追加する

- GoogleService-Info.plist のREVERSED_CLIENT_IDの値をコピーする

http://jesus9387.hatenablog.com/entry/2017/09/08/124052

- URL Typeにペースト

http://jesus9387.hatenablog.com/entry/2017/09/08/124052

## AppDelegateを編集

```swift
import UIKit
import CoreData
import Firebase
//追加
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        //追加
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()!.options.clientID
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    //　追加
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }


    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

```

## Storyboardにボタンを追加

- StoryBoardにViewを貼り付けクラスに``` GIDSignInButton ```を設定

http://jesus9387.hatenablog.com/entry/2017/09/08/124052


## ViewCotroller編集

```swift
import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    @IBAction func tapGoogleSingIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {


        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        let authentication = user.authentication
        // Googleのトークンを渡し、Firebaseクレデンシャルを取得する。
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,accessToken: (authentication?.accessToken)!)

        // Firebaseにログインする。
        Auth.auth().signIn(with: credential) { (user, error) in
            print("ログイン成功")
            //画面遷移処理
        }
    }
    //エラー処理
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Sign off successfully")
    }


}
```

## 完成

- ログインボタンをタップするとGoogleのログイン画面が表示されます。
http://jesus9387.hatenablog.com/entry/2017/09/08/124052


## よければ


- ソースは下記に置いたのでどうぞ
[https://github.com/yshogo/GoogleLoginSample:embed:cite]

- Twitterもフォローお願い致します。( https://twitter.com/yshogo87 )



