//
//  JSFliterManager.h
//  autoajust
//
//  Created by json on 14/10/20.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//
@protocol SendAdjustStateDelegate <NSObject>

-(void)sendAdjustState;

@end
#import <Foundation/Foundation.h>
//滤镜种类
enum FliterStyle
{
    KCIColorMonochrome=0,//黑白
    KCISepiaTone,//墨色调
    KCITemperatureAndTint,//色温
    KCIHueAdjust//饱和度
};
@interface JSFliterManager : NSObject
@property(nonatomic,strong) NSString *fliterName;//设置fliter名称
@property(nonatomic,strong)id<SendAdjustStateDelegate>adjustdelegate;
+(id)shareFliterManager;
-(void)setOriginalImage:(UIImage *)image;//传入需要处理的图像
-(void)choseFliterWithFliterStyle:(enum FliterStyle)fliter;//选择滤镜
-(UIImage *)getAfterTransWithValue:(CGFloat)value ;//根据滑块值处理图像
-(UIImage *)autoAdjustTheImageWithOriginalImage:(UIImage *)image;//自动改善
//- (void)showAllFilters; 显示所有滤镜
@end
