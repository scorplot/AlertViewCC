//
//  CCAlertView.m
//  Pods
//
//  Created by may on 2017/7/13.
//
//

#import "CCAlertView.h"

@interface CCAlertAction ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^handler)(CCAlertAction *);
@end

@implementation CCAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CCAlertAction * _Nullable))handler {
    return [[self alloc] initWithTitle:title handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(CCAlertAction *))handler {
    if (self = [super init]) {
        _title = title;
        if (handler) {
            _handler = handler;
        }
    }
    return self;
}

@end

typedef void(^customHandler)(UIView * _Nullable view);

@interface CCAlertView ()

@property (nonatomic, strong) NSMutableDictionary *actionDictionary; // 存储CCAlertAction key为index
@property (nonatomic, strong) UIView* view;
@property (nonatomic, copy) void(^showHandler)(); // 显示alert回调
@property (nonatomic, copy) void(^dismissHandler)(); // 隐藏alert回调
@property (nonatomic, copy) void(^addActionHandler)(CCAlertAction *action); // 添加action回调
@property (nonatomic, copy) void(^addViewHandler)(UIView *view,customHandler handler); // 添加自定义view回调

@end

static __strong CCAlertView *_pointer;

@implementation CCAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.superView = [[UIApplication sharedApplication].delegate window];
        self.actionDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)show {
    _show = YES;
    [self.superView addSubview:_view];
    _pointer = self;
    self.showHandler();
}

- (void)dismiss {
    _show = NO;
    [_view removeFromSuperview];
    _pointer = nil;
    _view = nil;
    if (self.dismissHandler) {
        self.dismissHandler();
    }
}
- (void)dealloc {
//    NSLog(@"%s",__FUNCTION__);
}
-(void)clickedTitle:(NSInteger)index {
    CCAlertAction* action = [self.actionDictionary objectForKey:@(index)];
    if ([action handler]) {
        action.handler(action);
    }
}
- (void)addAction:(CCAlertAction *_Nullable)action {
    self.addActionHandler(action);
}
-(void)addAction:(CCAlertAction*_Nullable)action index:(NSInteger)index {
    [self.actionDictionary setObject:action forKey:@(index)];
}
- (void)addCustomView:(UIView *_Nullable)view viewHandler:(customHandler)handler {
    self.addViewHandler(view,handler);
}
// 为了不报警告重写的，子类需重写这些方法

- (UIView *)customView:(UIView *)view index:(NSInteger)index {
    return nil;
}
- (UIView *)alertTitle:(NSString *)title message:(NSString *)message {
    return nil;
}
- (UIView *)customBtnWithTitle:(NSString *)title index:(NSInteger)index {
    return nil;
}

@end

@interface CCAlertFactory ()<UIAlertViewDelegate>

@property (nonatomic, strong) CCAlertView *alert;
@property (nonatomic, strong) id custom;

@end

@implementation CCAlertFactory

static Class _Nullable customViewClass = nil;

+ (instancetype)shareInstance {
    static CCAlertFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CCAlertFactory alloc] init];
    });
    return instance;
}
- (CCAlertView *_Nullable)createAlertView:(NSString *)message {
    return [self createAlertViewWithTitle:message message:nil style:UIAlertViewStyleDefault cancelAction:[CCAlertAction actionWithTitle:@"OK" handler:^(CCAlertAction * _Nullable action) {
        
    }] otherActions:nil, nil];
}
- (CCAlertView *)createAlertViewWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertViewStyle)alertViewStyle cancelAction:(CCAlertAction *)cancelAction otherActions:(CCAlertAction *)otherAction, ... {
    __block NSInteger btnCount = 1;
    __block NSInteger viewCount = 0;
    // 自定义alertView
    if (customViewClass) {
        self.custom = [[customViewClass alloc] init];
        // 判断自定义类是否继承与CCAlertView
        NSAssert([self.custom isKindOfClass:[CCAlertView class]]||[customViewClass isSubclassOfClass:[CCAlertView class]],@"customView must inherit from CCAlertView");
        if ([self.custom isKindOfClass:[CCAlertView class]] || [customViewClass isSubclassOfClass:[CCAlertView class]]) {
            __block CCAlertView *customView = self.custom;
            __weak CCAlertView *cc = customView;
            __block  UIView *v;
            // 添加自定义view
            customView.addViewHandler = ^(UIView *view, customHandler handler) {
                if ([cc respondsToSelector:@selector(customView:index:)]) {
                    v = [cc customView:view index:viewCount];
                    viewCount++;
                    handler(view);
                }
            };
            // 添加title和 message
            if ([customView respondsToSelector:@selector(alertTitle:message:)]) {
                v = [customView alertTitle:title message:message];
            }
            // 取消操作按钮 index为0
            if (cancelAction) {
                if ([customView respondsToSelector:@selector(customBtnWithTitle:index:)]) {
                    [customView addAction:cancelAction index:0];
                    v = [customView customBtnWithTitle:cancelAction.title index:0];
                }
            }
            va_list list;
            va_start(list, otherAction);
            // 其他操作按钮 index从1开始逐个递增
            for (CCAlertAction *action = otherAction; action != nil; action = va_arg(list, CCAlertAction*)) {
                [customView addAction:action index:btnCount];
                if ([customView respondsToSelector:@selector(customBtnWithTitle:index:)]) {
                    v = [customView customBtnWithTitle:action.title index:btnCount];
                }
                btnCount ++;
            }
            va_end(list);
            customView.showHandler = ^{
            };
            // alert隐藏时将view置为nil，使其被释放
            customView.dismissHandler = ^{
                customView = nil;
                _custom = nil;
            };
            // 单独添加操作按钮
            customView.addActionHandler = ^(CCAlertAction *action) {
                if ([cc respondsToSelector:@selector(customBtnWithTitle:index:)]) {
                    [cc addAction:action index:btnCount];
                    v = [cc customBtnWithTitle:action.title index:btnCount];
                    btnCount ++;
                }
            };
            customView.view = v;
            return customView;
        }
    }
    // 使用系统默认alertView
    self.alert = [[CCAlertView alloc] init];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelAction.title otherButtonTitles:nil, nil];
    if (cancelAction) {
        [self.alert addAction:cancelAction index:0];
    }
    alertView.alertViewStyle = alertViewStyle;
    self.alert.addViewHandler = ^(UIView *view, customHandler handler) {
        if ([view isKindOfClass:[UITextField class]]) {
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *t = [alertView textFieldAtIndex:0];
            handler(t);
        }
    };
    va_list list;
    va_start(list, otherAction);
    for (CCAlertAction *action = otherAction; action != nil; action = va_arg(list, CCAlertAction*)) {
        [self.alert addAction:action index:btnCount];
        [alertView addButtonWithTitle:action.title];
        btnCount ++;
    }
    va_end(list);
    self.alert.showHandler = ^{
        [alertView show];
    };
    __weak CCAlertFactory *ws = self;
    self.alert.addActionHandler = ^(CCAlertAction *action) {
        
        [ws.alert addAction:action index:btnCount];
        btnCount ++;
        [alertView addButtonWithTitle:action.title];
    };
    self.alert.view = alertView;
    return self.alert;
}
- (void)setCustomAlertViewWithClass:(Class _Nullable)viewClass {
    customViewClass = viewClass;
}

#pragma alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.alert clickedTitle:buttonIndex];
    self.alert = nil;
    
}
@end
