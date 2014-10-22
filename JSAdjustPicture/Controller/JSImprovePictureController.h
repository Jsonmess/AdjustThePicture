//
//  JSImprovePictureController.h
//  autoajust
//
//  Created by Json on 14-10-18.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSShowImage.h"
@interface JSImprovePictureController : UIViewController
@property (weak, nonatomic) IBOutlet JSShowImage *PictureView;
- (IBAction)dismissThisView:(id)sender;
- (IBAction)ajustPicture:(id)sender;
- (IBAction)savePictureToAlbum:(id)sender;
- (IBAction)AutoAdjustImage:(id)sender;


@end
