//
//  ORGIFController.h
//  GIFs
//
//  Created by Boris Bügling on 16/05/14.
//  Copyright (c) 2014 Team GIFs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIF;

@protocol ORGIFSource <NSObject>

- (void)getNextGIFs;
- (NSInteger)numberOfGifs;
- (GIF *)gifAtIndex:(NSInteger)index;

@end

@interface ORGIFController : UIViewController

@property (nonatomic, weak) id<ORGIFSource> source;

- (void)gotNewGIFs;

@end
