//
//  JSFlitersOperation.h
//  autoajust
//
//  Created by json on 14/10/20.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//
@protocol SendTheAdjustImageDelegate <NSObject>

-(void)sendTheAdjustImage:(UIImage *)adjustimage;

@end
#import <Foundation/Foundation.h>
@interface JSFlitersOperation : NSObject
@property (strong, nonatomic) IBOutlet UIView *flitersView;//滤镜视图
@property (weak, nonatomic) IBOutlet UIButton *vignetteEffectBtn;//晕影
@property (weak, nonatomic) IBOutlet UIButton *sepiaToneBtn;//棕黑
@property (weak, nonatomic) IBOutlet UIButton *vignetteBtn;//印花
@property (weak, nonatomic) IBOutlet UIButton *saturationBtn;//饱和度
@property (weak, nonatomic) IBOutlet UISlider *sliderValueBtn;//滑块
@property (strong, nonatomic)id<SendTheAdjustImageDelegate>delegate;
- (IBAction)choseFliterToAdjust:(UIButton *)sender;
- (IBAction)fliterValueChange:(id)sender;

@end
