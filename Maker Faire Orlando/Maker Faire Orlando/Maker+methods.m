//
//  Maker+methods.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "Maker+methods.h"
#import "DataManager.h"
#import "Faire+methods.h"
#import "Photo.h"
#import "NSManagedObject+methods.h"

#define kMakersURL @"http://callformakers.org/orlando2014/default/overviewALL.json/raw"

@implementation Maker (methods)

+ (void)updateMakers
{
    NSURL *makersURL = [NSURL URLWithString:kMakersURL];
    
    __weak NSURLSession *session = [[DataManager sharedDataManager] session];
    
    NSURLSessionDataTask *makersDownloadTask = [session dataTaskWithURL:makersURL
                                                      completionHandler:makersDownloadResponse];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [makersDownloadTask resume];
}

+ (NSArray *)stripMakersFromDictionary:(NSDictionary *)dict
{
    return [dict objectForKey:@"accepteds"];
}

+ (void)murderMakers
{
    [Maker murderTableWithEntityName:@"Maker"];
}

void (^makersDownloadResponse)(NSData *, NSURLResponse*, NSError*) = ^(NSData *data,NSURLResponse *response, NSError *error)
{
    NSString *notif = nil;
    if (error)
    {
        notif = kMakersFailed;
    }
    else
    {
        notif = kMakersArrived;
        
        [Maker murderMakers];
        
        NSManagedObjectContext *context = [Maker defaultContext];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        Faire *currentFaire = [Faire currentFaire];
        
        if (currentFaire == nil)
        {
            // Setup Faire first, then add makers
            
            Faire *newCurrentFaire = [NSEntityDescription insertNewObjectForEntityForName:@"Faire"
                                                                   inManagedObjectContext:context];
            
            [newCurrentFaire setTitle:[dict objectForKey:@"title"]];
            
            if ([[dict objectForKey:@"volunteer_link"] isKindOfClass:[NSString class]])
            {
                [newCurrentFaire setVolunteerURL:[dict objectForKey:@"volunteer_link"]];
            }
            
            [newCurrentFaire setSponsorURL:[dict objectForKey:@"sponsor_link"]];
            [newCurrentFaire setAboutURL:[dict objectForKey:@"about_link"]];
            [newCurrentFaire setAttendURL:[dict objectForKey:@"attend_link"]];
            [newCurrentFaire setCurrent:@1];
            
            currentFaire = newCurrentFaire;
        }
        
        NSArray *makers = [Maker stripMakersFromDictionary:dict];
        
        for (NSDictionary *maker in makers)
        {
            Maker *newMaker = [NSEntityDescription insertNewObjectForEntityForName:@"Maker"
                                                            inManagedObjectContext:context];
            //                newMaker setTitle:[maker objectForKey:<#(id)#>
            [newMaker setFaire:             currentFaire];
            [currentFaire addMakersObject:  newMaker];
            
            [newMaker setDescript:          [maker objectForKey:@"description"]];
            [newMaker setCategories:        [maker objectForKey:@"category"]];
            //                newMaker setMakerName:[maker objectForKey:];
            [newMaker setLocation:          [maker objectForKey:@"location"]];
            [newMaker setOrganization:      [maker objectForKey:@"organization"]];
            [newMaker setProjectName:       [maker objectForKey:@"project_name"]];
            [newMaker setSummary:           [maker objectForKey:@"project_short_summary"]];
            [newMaker setVideoURL:          [maker objectForKey:@"video_link"]];
            [newMaker setWebsiteURL:        [maker objectForKey:@"web_site"]];
            
            NSString *photoLocation = [maker objectForKey:@"photo_link"];
            
            if (photoLocation != nil && ![photoLocation isEqualToString:@""])
            {
                Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                                inManagedObjectContext:context];
                [newPhoto setSourceURL:photoLocation];
                [newPhoto setMaker:newMaker];
                
                [newMaker addPhotosObject:newPhoto];
                
                [context save:nil];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:notif object:nil];
    });
};

@end
