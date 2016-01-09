//
//  ViewController.m
//  Demo2
//
//  Created by 生龙 on 16/1/7.
//  Copyright © 2016年 龙. All rights reserved.
//

///  解决内存问题和闪烁问题
///

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *launchView;
@property (nonatomic,strong)NSMutableArray *images;

@end

@implementation ViewController

-(NSMutableArray *)images{
    
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startAnim];
}

-(void)startAnim{

    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    for (int i = 1; i < 7 ; i ++) {
//        
        NSString *imageName = [NSString stringWithFormat:@"%02d.png",i];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
        
        // 这个地方一定要用CGImage，因为动画是对layer进行操作
        [self.images addObject:(__bridge UIImage*)image.CGImage];
        
    }
    keyAnim.values = self.images;
    keyAnim.delegate = self;
    keyAnim.duration = self.images.count * 0.2;
    // 设置fillmode
    // 设置这两个属性让他执行完还是在那个页面，避免两个动画切换闪烁
    keyAnim.fillMode = kCAFillModeForwards;
    keyAnim.removedOnCompletion = NO;

    [self.launchView.layer addAnimation:keyAnim forKey:@"keyAnim"];
}

-(void)basicAnim{
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"contents"];
    
    NSString *imageName1 = [NSString stringWithFormat:@"06.png"];
    NSString *imageName2 = [NSString stringWithFormat:@"07.png"];

    UIImage *fromaImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName1 ofType:nil]];
    UIImage *toImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName2 ofType:nil]];
    
    // 这个地方一定要用CGImage，因为动画是对layer进行操作
    anim.fromValue = (__bridge id _Nullable)(fromaImage.CGImage);
    anim.toValue = (__bridge id _Nullable)(toImage.CGImage);
    
    anim.duration = 0.8;
    anim.delegate = self;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.repeatCount = 1;

    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [self.launchView.layer addAnimation:anim forKey:@"basicAnim"];

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.launchView.layer removeAllAnimations];

    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        self.launchView.image = [UIImage imageNamed:@"07"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.launchView removeFromSuperview];
        });
        // 释放图片内存
        self.images = nil;
        return;
    }
    [self basicAnim];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
