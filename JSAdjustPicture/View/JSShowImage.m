//
//  JSShowImage.m
//  autoajust
//
//  Created by json on 14/10/20.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSShowImage.h"

@implementation JSShowImage

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.touchDelegate pickImageFromALAssetsLibrary];
}

@end
