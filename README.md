# AlertViewCC

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

AlertViewCC is available through cocoaoods. To install
it, simply add the following line to your Podfile:

```ruby
pod "AlertViewCC"
```

## Author

caomeili, may1124521@yahoo.com


#### 使用方法

1. 基本使用

```
#import <AlertViewCC.h>
E.g: 
[[[CCAlertFactory  shareInstance] createAlertViewWithTitle:@"aaa" message:@"bbb" style:UIAlertViewStyleDefault cancelAction:[QZAlertAction actionWithTitle:@"取消" handler:^(QZAlertAction * _Nullable action) {
    }] otherActions:[QZAlertAction actionWithTitle:@"1" handler:^(QZAlertAction * _Nullable action) {
    }], nil] show];
```

2. 自定义alertView

```
#import <AlertViewCC.h>
#import <CCImitationAlertView.h> // 高仿alertView
E.g: 
[[CCAlertFactory shareInstance] setCustomAlertViewWithClass:[QZImitationAlertView class]];
```
