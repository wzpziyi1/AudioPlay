//
//  AppDelegate.h
//  AudioPlayer
//
//  Created by 王志盼 on 2017/6/29.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

