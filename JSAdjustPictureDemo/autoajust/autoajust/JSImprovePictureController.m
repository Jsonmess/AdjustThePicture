//
//  JSImprovePictureController.m
//  autoajust
//
//  Created by Json on 14-10-18.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSImprovePictureController.h"
#import "JSFlitersOperation.h"
#import "JSFliterManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface JSImprovePictureController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AddImageToImageViewDelegate,SendTheAdjustImageDelegate,SendAdjustStateDelegate>
{
    UIImagePickerController *_imagePicker;//照片选择器
    JSFlitersOperation *_fliterOperation;//滤镜工具栏
    BOOL _isOpenFliter;//是否显示滤镜工具栏
  
}
@end

@implementation JSImprovePictureController
#pragma mark---初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    //设置站位图片
    [self.PictureView setImage:[UIImage imageNamed:@"pictureview_bg.png"]];
    [self.PictureView setTouchDelegate:self];
    [self setUpView];
    //初始化滤镜工具栏显示状态
    _isOpenFliter=NO;

    [super viewDidLoad];
    
    
}
-(void)setUpView
{
    //添加滤镜视图
    if (_fliterOperation==nil) {
        _fliterOperation=[[JSFlitersOperation alloc]init];
    }
    float locationY= CGRectGetMaxY(self.PictureView.frame);
    //将滤镜工具视图定位到屏幕外位置
    [_fliterOperation.flitersView setCenter:CGPointMake(self.view.bounds.size.width+_fliterOperation.flitersView.bounds.size.width *0.5f, locationY+_fliterOperation.flitersView.bounds.size.height *0.5f)];
        //设置代理
    [_fliterOperation setDelegate:self];
    [[JSFliterManager shareFliterManager] setAdjustdelegate:self];
    [self.view addSubview:_fliterOperation.flitersView];
}
-(void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
     [self InitImagePickerView];
   
}
-(void)InitImagePickerView
{
    
    if (!_imagePicker) {
        _imagePicker =[[UIImagePickerController alloc]init];
    }
    [_imagePicker setAllowsEditing:YES];
    [_imagePicker setDelegate:self];
    [_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    
}

#pragma mark---代理function,图片质量压缩-防止图片过大引起内存不足。
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
    NSData *imagedata=UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.5f);
    [_PictureView setImage:[UIImage imageWithData:imagedata]];
    //向滤镜manager 传入图像
    [[JSFliterManager shareFliterManager] setOriginalImage:[UIImage imageWithData:imagedata]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)pickImageFromALAssetsLibrary
{
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
-(void)sendTheAdjustImage:(UIImage *)adjustimage
{
    //主线程更新视图
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_PictureView setImage:adjustimage];
    });
}
#pragma mark--改善完成后的通知
-(void)sendAdjustState
{
    [self showAlertWithmessage:@"自动调节照片完成"];
}
- (IBAction)dismissThisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//滤镜栏操作
- (IBAction)ajustPicture:(id)sender {
    
    if (!_isOpenFliter) {
        [UIView animateWithDuration:0.4f animations:^{
    _fliterOperation.flitersView.transform=CGAffineTransformMakeTranslation((self.view.bounds.size.width+_fliterOperation.flitersView.bounds.size.width) *-0.5f, 0);
        }];
    }else
    {
        [UIView animateWithDuration:0.5f animations:^{
            [_fliterOperation.flitersView setTransform:CGAffineTransformIdentity];
        }];
    }
    _isOpenFliter=_isOpenFliter==YES?NO:YES;
}
#pragma mark---保存处理后的照片
- (IBAction)savePictureToAlbum:(id)sender {
    
    ALAssetsLibrary*library=[[ALAssetsLibrary alloc]init];
    [library writeImageToSavedPhotosAlbum:[_PictureView.image CGImage] orientation:(ALAssetOrientation)[_PictureView.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error==nil) {
            [self showAlertWithmessage:@"保存照片成功"];
        }else
             [self showAlertWithmessage:@"保存照片失败,请重试"];
    }];
    
    
}
//自动改善
- (IBAction)AutoAdjustImage:(id)sender {
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
  _PictureView.image=[[JSFliterManager shareFliterManager]autoAdjustTheImageWithOriginalImage:_PictureView.image];
    });
}
-(void)showAlertWithmessage:(NSString*)msg
{
    UIAlertView *alert;
    if (alert==nil) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
    }
    [alert setTitle:@"提示"];
    [alert setMessage:msg];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
