//
//  JSFlitersOperation.m
//  autoajust
//
//  Created by json on 14/10/20.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSFlitersOperation.h"
#import "JSFliterManager.h"
@interface JSFlitersOperation()
{
    NSArray *_views;
    UIButton *_oldBtn;//记录上一次选择的按钮
    JSFliterManager *_fliterManager;
}
@end
@implementation JSFlitersOperation

-(instancetype)init
{
    if (self=[super init]) {
        [self loadNib];
    }
    return self;
}
-(void)loadNib
{
    _views=[[NSBundle mainBundle]loadNibNamed:@"Fliters" owner:self options:nil];
    //初始化
    _fliterManager=[JSFliterManager shareFliterManager];
    
}

-(UIView *)flitersView
{
    if (!_flitersView) {
        _flitersView=_views[0];
    }
    return _flitersView;
}
-(void)doExtrainitWithTag:(int)tag
{
     //选择滤镜
    if (tag==3) {
        _fliterManager.fliterName=@"inputAngle";
    }else {
        _fliterManager.fliterName=@"inputIntensity";
    }

    [_fliterManager choseFliterWithFliterStyle:tag];
    //设置滑块的最大最小值和初始值
    
    switch (tag) {
        case 0://晕影
            [self.sliderValueBtn setMaximumValue:1.0f];
            [self.sliderValueBtn setMinimumValue:-1.0f];
            [self.sliderValueBtn setValue:-1.0f];
            break;
        case 1://棕黑
            [self.sliderValueBtn setMaximumValue:1.0f];
            [self.sliderValueBtn setMinimumValue:-1.0f];
            [self.sliderValueBtn setValue:-1.0f];
            break;
        case 2://印花
            [self.sliderValueBtn setMaximumValue:1.0f];
            [self.sliderValueBtn setMinimumValue:0.0f];
            [self.sliderValueBtn setValue:0.0f];
            break;
        case 3://饱和度
            [self.sliderValueBtn setMaximumValue:M_PI];
            [self.sliderValueBtn setMinimumValue:-M_PI];
            [self.sliderValueBtn setValue:-M_PI];
            break;
        default:
            break;
    }
 
}
- (IBAction)choseFliterToAdjust:(UIButton *)sender {
    if (_oldBtn==nil) {
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        _oldBtn=sender;
        [self doExtrainitWithTag:sender.tag];
    }else if(_oldBtn.tag!=sender.tag)
    {
        [_oldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _oldBtn=sender;
         [self doExtrainitWithTag:sender.tag];
    }

}
- (IBAction)fliterValueChange:(UISlider *)sender {
   //开启线程
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_async(queue, ^{
         [self.delegate sendTheAdjustImage:[_fliterManager getAfterTransWithValue:sender.value]];
     });
    
}
@end
