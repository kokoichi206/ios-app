HStack, VStack, ZStack(z-index),

Every @State is a source of truth


## XCode 操作
Command + R: Rebuild

Color Palette: Edit -> Format -> Show Colors


## Code

### guard
``` swift
// Count down is over or not
func track() {
    guard fastingState != .notStarted else { return }
    
    print("scheduledTime", Date().formatted(.dateTime.month().day().hour().minute().second()))

    if endTime >= Date() {
        print("Not elapsed")
        elapsed = false
    } else {
        print("elapsed")
        elapsed = true
    }
}
```

### API通信

#### Combine
Combine とは Apple 製のリアクティブプログラミングのフレームワーク

大きな概念として以下の２つ

- Publisher
    - 時系列順にイベントを発火する
    - さまざまな operator によってイベントを加工して流したり、複数の Publisher を合成して１つのストリームにできる
- Subscriber
    - Publisher を subscribe してイベントを受け取る
    - 返り値の cancellable を保持しておくことで任意のタイミングでキャンセルすることも可能

