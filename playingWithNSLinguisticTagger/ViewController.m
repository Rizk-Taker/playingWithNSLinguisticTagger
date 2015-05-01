//
//  ViewController.m
//  playingWithNSLinguisticTagger
//
//  Created by Nicolas Rizk on 4/9/15.
//  Copyright (c) 2015 Flatiron School. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD.h>

@interface ViewController () <MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *article1WV;
@property (weak, nonatomic) IBOutlet UIWebView *article2WV;

@property (weak, nonatomic) IBOutlet UITextField *article1TF;
@property (weak, nonatomic) IBOutlet UITextField *article2TF;
- (IBAction)article1Tapped:(id)sender;
- (IBAction)article2Tapped:(id)sender;
- (IBAction)analyzeTapped:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"How it works" message:@"This project allows you to load two web pages (preferrably articles) and compares the difference in the amount of negative words that appear in each one, creating a 'Negative Sentiment Score'." delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    
    [alert show];
}

- (void)compareNegativeWords {
    
    NSString *article1 = [self getHTMLStringVersionOfArticleWithURL:[NSURL URLWithString:self.article1TF.text]];
    NSString *article2 = [self getHTMLStringVersionOfArticleWithURL:[NSURL URLWithString:self.article2TF.text]];
    
    CGFloat article1Score = [self processNaturalLanguageWithString:article1];
    CGFloat article2Score = [self processNaturalLanguageWithString:article2];
    
    CGFloat difference = fabs(article1Score - article2Score);
    
    NSString *outcome;
    
    if (article1Score > article2Score) {
        outcome = [NSString stringWithFormat:@"Article 1's Negative Sentiment Score is %.1f points higher than Article 2's", difference];
        
    } else if (article2Score > article1Score) {
        outcome = [NSString stringWithFormat:@"Article 2's Negative Sentiment Score is %.1f points higher than Article 1's", difference];
        
    } else if (article1Score == article2Score) {
        outcome = [NSString stringWithFormat:@"Negative sentiment score is the same."];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:outcome delegate:self cancelButtonTitle:@"Word" otherButtonTitles:nil];
    
    [alert show];
    
}

- (CGFloat)processNaturalLanguageWithString: (NSString *)string {
    
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: [NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:options];
    
    tagger.string = string;
    
    __block NSInteger negativeWordCounter = 0;
    __block CGFloat negativeToTotalWordRatio = 0;
    
    [tagger enumerateTagsInRange:NSMakeRange(0, [string length])
                          scheme:NSLinguisticTagSchemeLemma
                         options:options
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
     {
         NSString *token = [string substringWithRange:tokenRange];

         
         NSMutableDictionary *tags = [[NSMutableDictionary alloc] init];
         
         if (tag != nil) {
             
             [tags setValue:tag forKey:token];
         }
         
         NSMutableArray *totalWords = [[NSMutableArray alloc] init];
         
         for (id key in tags) {
             
             [totalWords addObject:tags[token]];
             
             for (NSInteger i = 0; i < [[self negativeWords] count]; i++) {
                 
                 if ([[tags objectForKey:key] isEqualToString:[self negativeWords][i]]) {
                     
                     negativeWordCounter++;
                     negativeToTotalWordRatio = negativeWordCounter/[totalWords count];
                 }
             }
         }
     }];
    
    return negativeToTotalWordRatio;
}

- (NSArray *) negativeWords
{
    return @[@"no", @"not", @"none", @"nobody", @"nothing", @"nowhere", @"never", @"hardly", @"scrutinize", @"bare", @"hard", @"is not"];
}

- (NSURL *)loadWebviewWithString:(NSString *)string andWebview:(UIWebView *)webView {
    
    NSString *urlString = string;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    return url;
}

- (NSString *)getHTMLStringVersionOfArticleWithURL: (NSURL *)url {
    
    NSError *error;
    NSString *htmlPage = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    
    return htmlPage;
}

- (IBAction)article1Tapped:(id)sender {
    
    [self loadWebviewWithString:self.article1TF.text andWebview:self.article1WV];
    
    [self.view endEditing:YES];
}

- (IBAction)article2Tapped:(id)sender {
    
    [self loadWebviewWithString:self.article2TF.text andWebview:self.article2WV];
    
    [self.view endEditing:YES];
}


- (IBAction)analyzeTapped:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self compareNegativeWords];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

@end
