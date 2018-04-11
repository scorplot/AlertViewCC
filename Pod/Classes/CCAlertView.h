//
//  CCAlertView.h
//  Pods
//
//  Created by may on 2017/7/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 当添加或点击alertView 某个控件时使用该类

@interface CCAlertAction : NSObject

@property (nonatomic,copy,readonly) NSString * _Nullable title; // 被操作控件的名称

/**
  初始化方法
 
 @param title 控件要显示的title
 @param handler block回调，供外部获取有关控件的属性
 @return CCAlertAction对象
 */
+ (instancetype _Nullable )actionWithTitle:(NSString *_Nullable)title handler:(void (^_Nullable)(CCAlertAction * _Nullable action))handler;

@end

// alertView 控制类  自定义alertView需要继承该类，并按需求重写方法

@interface CCAlertView : NSObject

@property (nonatomic,strong) UIView * _Nullable superView; // alertView 的superView 默认 window
@property (nonatomic, assign, readonly, getter=isShow) BOOL show;//是否正在显示
- (void)addAction:(CCAlertAction *_Nullable)action; // 给alertView添加CCAlertAction对象
- (void)show; // 显示alert
- (void)dismiss; // 隐藏alert
/**
 添加自定义view

 当使用默认alertView 即 系统alert时，只能添加UITextField
 当使用CCAlertView子类，自定义alertView时，可以添加任意UIView
 添加的view会在重写的方法- (UIView *_Nullable)customView:(UIView *_Nullable)view index:(NSInteger)index; 中获得
 
 @param view 自定义view
 @param handler block回调，供外部获取自定义view
 */
- (void)addCustomView:(UIView *_Nullable)view viewHandler:(void (^_Nullable)(UIView * _Nullable view))handler;

#pragma mark 自定义alertView时才可以调用以下方法
-(void)clickedTitle:(NSInteger)index; // 当点击某控件时，需要CCAlertAction进行回调，调用此方法
#pragma mark 自定义alertView时重写以下方法

/**
 自定义alertView 子类需要重写该方法
 
 @param title 控件需要显示的title
 @param index 控件的index，该index需要保存下来用到-(void)clickedTitle:(NSInteger)index 中
 @return alertView本身
 */
- (UIView *_Nullable)customBtnWithTitle:(NSString *_Nullable)title index:(NSInteger)index;

/**
 自定义alertView 子类需要重写该方法

 @param title 控件需要显示的title
 @param message 控件需要显示的message
 @return alertView本身
 */
- (UIView *_Nullable)alertTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;

/**
 自定义alertView 子类需要重写该方法

 @param view 外部自定义view
 @param index 添加view时view的index，多个view时可根据index区分
 @return alertView本身
 */
- (UIView *_Nullable)customView:(UIView *_Nullable)view index:(NSInteger)index;
@end


// alertView创建样式类
@interface CCAlertFactory : NSObject

+ (instancetype _Nullable )shareInstance; // 单例，获取CCAlertFactory对象
- (CCAlertView *_Nullable)createAlertView:(NSString *)message;
/**
 创建alertView 样式

 @param title alertView要显示的title
 @param message alertView要显示的message
 @param alertViewStyle 只在使用默认alertView时起作用
 @param cancelAction alertView取消操作对象，使用CCActionSheetAction 类方法actionWithTitle:(NSString *_Nullable)title handler:(void (^_Nullable)(CCAlertAction * _Nullable action))handler  获取
 @param otherAction alertView其他操作对象，获取方法同上，可以添加多个，用','隔开
 @return alertView对象
 */
- (CCAlertView *_Nullable)createAlertViewWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message style:(UIAlertViewStyle)alertViewStyle cancelAction:(CCAlertAction *_Nullable)cancelAction otherActions:(CCAlertAction *_Nullable)otherAction, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setCustomAlertViewWithClass:(Class _Nullable)viewClass; // 设置自定义alertView ，传入view的class

@end
