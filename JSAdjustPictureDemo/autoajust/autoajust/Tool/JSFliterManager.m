//
//  JSFliterManager.m
//  autoajust
//
//  Created by json on 14/10/20.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSFliterManager.h"
@interface JSFliterManager()
{
    CIContext *_glContext;//上下文(GPU处理图像)
    CIFilter *_filter;//滤镜
    UIImage *_originalImage;//传入需要处理的图片

}
@end
@implementation JSFliterManager
static  JSFliterManager*_instance;
#pragma mark----创建单例
+(id)shareFliterManager
{
    if (_instance==nil) {
        _instance=[[self alloc]init];
    }
    return _instance;
}
+(id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[super allocWithZone:zone];
    });
    return _instance;
}
-(instancetype)init
{
    if (self=[super init]) {
        if (!_glContext) {
            [self createContext];
        }
    }
    return self;
}
-(void)createContext
{
    if (_glContext==nil) {
        EAGLContext *context=[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (context!=nil) {
            _glContext =[CIContext contextWithEAGLContext:context];
        }
        
    }
}
//根据枚举值创建滤镜
-(CIFilter *)getFliterWithFliterStyle:(enum FliterStyle)fliter
{
    CIFilter *filter;
    switch (fliter) {
        case 0:
            
            filter=[CIFilter filterWithName:@"CIVignetteEffect"];
            break;
        case 1:
             filter=[CIFilter filterWithName:@"CISepiaTone"];
            break;
        case 2:
             filter=[CIFilter filterWithName:@"CIColorMonochrome"];
            break;
        case 3:
             filter=[CIFilter filterWithName:@"CIHueAdjust"];
            break;
        default:
            break;
    }
    return filter;
}
#pragma mark---根据传入image
-(void)setOriginalImage:(UIImage *)image
{
    _originalImage=image;
    
}
#pragma mark---//传入滤镜
-(void)choseFliterWithFliterStyle:(enum FliterStyle)fliter
{
    _filter=[self getFliterWithFliterStyle:fliter];
}

-(UIImage *)getAfterTransWithValue:(CGFloat)value
{
   
    [_filter setValue:[CIImage imageWithCGImage:_originalImage.CGImage] forKey:kCIInputImageKey];
      [_filter setValue:[NSNumber numberWithFloat:value] forKey:_fliterName];
  
  
    CIImage *outputImage = [_filter outputImage];
   
    CGImageRef imageref = [_glContext createCGImage:outputImage fromRect:[outputImage extent]];
   UIImage *newimage= [UIImage imageWithCGImage:imageref];

    CGImageRelease(imageref);
    return newimage;
}
#pragma mark--自动改善
-(UIImage *)autoAdjustTheImageWithOriginalImage:(UIImage *)image
{
    CIImage *originalImage=[CIImage imageWithCGImage:image.CGImage];
    CIImage *outputImage=originalImage;
    NSArray *autoFliters=[originalImage autoAdjustmentFilters];
        for (CIFilter *filter in autoFliters) {
            [filter setValue:outputImage forKey:kCIInputImageKey];
        outputImage=[filter outputImage];
        }
   CGImageRef imageref = [_glContext createCGImage:outputImage fromRect:[outputImage extent]];
   UIImage *newimage= [UIImage imageWithCGImage:imageref];
    CGImageRelease(imageref);
    [self.adjustdelegate sendAdjustState];
    return newimage;
}
#pragma mark----显示所有可用滤镜名和其所需参数
//- (void)showAllFilters
//{
//    NSArray *properties = [CIFilter filterNamesInCategory:
//                           kCICategoryBuiltIn];
//    NSLog(@"FilterName:\n%@", properties);
//    for (NSString *filterName in properties) {
//        CIFilter *fltr = [CIFilter filterWithName:filterName];
//        NSLog(@"%@:\n%@", filterName, [fltr attributes]);
//        
//    }
//    
//}


@end
