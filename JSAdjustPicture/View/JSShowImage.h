//
//  JSShowImage.h
//  autoajust
//
//  Created by json on 14/10/20.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddImageToImageViewDelegate
-(void)pickImageFromALAssetsLibrary;
@end
@interface JSShowImage : UIImageView
@property(nonatomic,strong)id<AddImageToImageViewDelegate>touchDelegate;

@end
