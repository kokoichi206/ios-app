HStack, VStack, ZStack(z-index),

Every @State is a source of truth


## XCode 操作
Command + R: Rebuild



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
