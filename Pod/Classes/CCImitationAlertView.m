//
//  CCImitationAlertView.m
//  Pods
//
//  Created by may on 2017/7/13.
//
//

#import "CCImitationAlertView.h"

#define ALERT_WIDTH 270
#define ALERT_MIN_HEIGHT 44

@interface CCImitationAlertView ()
@property (nonatomic, strong) UIView *alertBackView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic,copy) NSString * _Nullable title;
@property (nonatomic,copy) NSString * _Nullable message;
@property (nonatomic, strong) NSMutableDictionary *buttonsDictionary;
@property (nonatomic, strong) NSMutableDictionary *customViewDictionary;
@property (nonatomic, strong) NSMutableArray *buttonsArray;

@end

@implementation CCImitationAlertView
- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.buttonsDictionary = [NSMutableDictionary dictionary];
        self.customViewDictionary = [NSMutableDictionary dictionary];
        self.buttonsArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}
- (UIView *)setupUI {
    [self.alertBackView addSubview:self.alertView];
    [self.alertView addSubview:self.titleLabel];
    [self.alertView addSubview:self.detailLabel];
    
    return self.alertBackView;
}
- (void)dealloc {
//    NSLog(@"%s",__FUNCTION__);
}

- (void)layoutSubviews {
    CGFloat alertHeight = 0;
    self.titleLabel.text = self.title;
    self.detailLabel.text = self.message;
    CGRect titleLabelFrame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(ALERT_WIDTH - 20, 20000.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil];
    if (titleLabelFrame.size.height > 0) {
        self.titleLabel.frame = CGRectMake(10, 12, ALERT_WIDTH - 20, CGRectGetHeight(titleLabelFrame));
        alertHeight += (CGRectGetHeight(titleLabelFrame) + 12);
    }
    CGRect detailLabelFrame = [self.detailLabel.text boundingRectWithSize:CGSizeMake(ALERT_WIDTH - 20, 20000.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.detailLabel.font} context:nil];
    if (detailLabelFrame.size.height > 0) {
        self.detailLabel.frame = CGRectMake(10, alertHeight + 4, ALERT_WIDTH - 20, CGRectGetHeight(detailLabelFrame));
        alertHeight += (CGRectGetHeight(detailLabelFrame) + 4);
    }
    
    if (self.customViewDictionary.allValues.count > 0) {
        for (int i = 0; i < self.customViewDictionary.allKeys.count; i++) {
            
            UIView *view = [self.customViewDictionary objectForKey:self.customViewDictionary.allKeys[i]];
            view.frame = CGRectMake(10,alertHeight + 16, ALERT_WIDTH - 20, CGRectGetHeight(view.frame));
            alertHeight += (CGRectGetHeight(view.frame) + 8);
            [self.alertView addSubview:view];
        }
    }
    
    for (int i = 0; i < self.buttonsDictionary.allKeys.count; i++) {
        NSNumber *number = self.buttonsDictionary.allKeys[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.buttonsDictionary objectForKey:number] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:247.0/255.0 alpha:1] forState:UIControlStateNormal];
        button.tag = 1000 + [self.buttonsDictionary.allKeys[i] integerValue];
        if (self.buttonsDictionary.allKeys.count == 2) {
            button.frame = CGRectMake(CGRectGetWidth(self.alertView.frame)/2 * i,alertHeight + 10, CGRectGetWidth(self.alertView.frame)/2, ALERT_MIN_HEIGHT);
            CALayer * horizonLayer = [CALayer layer];
            horizonLayer.frame = CGRectMake(0, CGRectGetMinY(button.frame), CGRectGetWidth(self.alertView.frame), 0.5);
            horizonLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
            [self.alertView.layer addSublayer:horizonLayer];
            
            CALayer *verticalLine = [CALayer layer];
            verticalLine.frame = CGRectMake(CGRectGetWidth(button.frame), alertHeight + 10, 0.5, CGRectGetHeight(button.frame));
            verticalLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
            [self.alertView.layer addSublayer:verticalLine];

        } else {
            button.frame = CGRectMake(0,alertHeight + 10 + (ALERT_MIN_HEIGHT + 4)*i, CGRectGetWidth(self.alertView.frame), ALERT_MIN_HEIGHT);
            CALayer * horizonLayer = [CALayer layer];
            horizonLayer.frame = CGRectMake(0, CGRectGetMinY(button.frame), CGRectGetWidth(self.alertView.frame), 0.5);
            horizonLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
            [self.alertView.layer addSublayer:horizonLayer];
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:button];
    }
    if (self.buttonsDictionary.allKeys.count == 2) {
        alertHeight += ALERT_MIN_HEIGHT;
    } else if (self.buttonsDictionary.allKeys.count > 0) {
        alertHeight += ((ALERT_MIN_HEIGHT + 4) * self.buttonsDictionary.allKeys.count);
    }
    self.alertView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - ALERT_WIDTH)/2, ([UIScreen mainScreen].bounds.size.height - (alertHeight + 12))/2, ALERT_WIDTH, alertHeight + 12);
    
}
- (void)clickButton:(UIButton *)button {
    [self clickedTitle:(button.tag - 1000)];
    [self dismiss];
}
- (UIView *)alertBackView {
    if (!_alertBackView) {
        _alertBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _alertBackView;
}
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALERT_WIDTH, ALERT_MIN_HEIGHT)];
        _alertView.backgroundColor =  [UIColor whiteColor];
        _alertView.layer.cornerRadius =  20;
        _alertView.center = [[UIApplication sharedApplication].delegate window].center;
    }
    return _alertView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor =  [UIColor blackColor];//
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:10];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}
- (void)animation {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.98, 0.98, 0.98)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_alertView.layer addAnimation:animation forKey:nil];
}

// 重写父类方法

// 重写show方法并调用父类方法，对alertView重新布局
- (void)show {
    [super show];
    [self animation];
    [self layoutSubviews];
}

- (UIView *)customBtnWithTitle:(NSString *)title index:(NSInteger)index{
    [self.buttonsDictionary setObject:title forKey:@(index)];
    return self.alertBackView;
}
- (UIView *)alertTitle:(NSString *)title message:(NSString *)message {
    self.title = title;
    self.message = message;
    return self.alertBackView;
}
- (UIView *)customView:(UIView *)view index:(NSInteger)index{
    [self.customViewDictionary setObject:view forKey:@(index)];
    return self.alertBackView;
}
@end
