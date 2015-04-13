//
//  ViewController.m
//  playingWithNSLinguisticTagger
//
//  Created by Nicolas Rizk on 4/9/15.
//  Copyright (c) 2015 Flatiron School. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *article1WV;
@property (weak, nonatomic) IBOutlet UIWebView *article2WV;

@property (weak, nonatomic) IBOutlet UITextField *article1TF;
@property (weak, nonatomic) IBOutlet UITextField *article2TF;
@property (weak, nonatomic) IBOutlet UILabel *outcomeLabel;
- (IBAction)article1Tapped:(id)sender;
- (IBAction)article2Tapped:(id)sender;
- (IBAction)analyzeTapped:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void) compareNegativeWords
{
    NSString *article1 = [self getHTMLStringVersionOfArticleWithURL:[NSURL URLWithString:self.article1TF.text]];
    NSString *article2 = [self getHTMLStringVersionOfArticleWithURL:[NSURL URLWithString:self.article2TF.text]];
    
    NSInteger article1Score = [self processNaturalLanguageWithString:article1];
    NSInteger article2Score = [self processNaturalLanguageWithString:article2];
    
    NSInteger difference = abs(article1Score - article2Score);
    
    if (article1Score > article2Score) {
        self.outcomeLabel.hidden = NO;
        NSString *outcome1 = [NSString stringWithFormat:@"Negative sentiment is higher for the first article by %li points.", difference];
        [self.outcomeLabel setText:outcome1];
    }
    else if (article2Score > article1Score)
    {
        self.outcomeLabel.hidden = NO;
        NSString *outcome2 = [NSString stringWithFormat:@"Negative sentiment is higher for the second article by %li points.", difference];
        [self.outcomeLabel setText:outcome2];
    }
    
    else if (article1Score == article2Score)
    {
        self.outcomeLabel.hidden = NO;
        NSString *outcome3 = [NSString stringWithFormat:@"Negative sentiment score is the same."];
        [self.outcomeLabel setText:outcome3];
    }
    
}

- (NSInteger) processNaturalLanguageWithString: (NSString *)string
{
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: [NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:options];
    
    tagger.string = string;
    
    __block NSInteger negativeWordCounter = 0;
    
    [tagger enumerateTagsInRange:NSMakeRange(0, [string length])
                          scheme:NSLinguisticTagSchemeLemma
                         options:options
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
     {
         NSString *token = [string substringWithRange:tokenRange];
//
         NSMutableDictionary *tags = [[NSMutableDictionary alloc] init];
//         if (token) {
//
//         }
         if (tag != nil) {
             NSLog(@"%@ : %@", token, tag);
             [tags setValue:tag forKey:token];
         }
         for (id key in tags) {
             if ([[tags objectForKey:key] isEqualToString:[self negativeWords][0]]) {
                 negativeWordCounter++;
                 NSLog(@"Inside of block %i", negativeWordCounter);
             }
         }
  
     }];
    NSLog(@"Outside of block %i", negativeWordCounter);
    return negativeWordCounter;
}

- (NSArray *) negativeWords
{
    //    No
    //    Not
    //    None
    //    No one
    //    Nobody
    //    Nothing
    //    Neither
    //    Nowhere
    //    Never
    //    Negative Adverbs:
    //
    //    Hardly
    //    Scarcely
    //    Barely
    //    Negative verbs:
    //
    //    Doesn’t
    //    Isn’t
    //    Wasn’t
    //    Shouldn’t
    //    Wouldn’t
    //    Couldn’t
    //    Won’t
    //    Can’t
    //    Don’t
    return @[@"clinton"];
}

- (NSURL *) loadWebviewWithString:(NSString *)string andWebview:(UIWebView *)webView
{
    NSString *urlString = string;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    return url;
}

- (NSString *) getHTMLStringVersionOfArticleWithURL: (NSURL *)url {
    NSError *error;
    NSString *htmlPage = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    
    return htmlPage;
}

- (IBAction) article1Tapped:(id)sender
{
    [self loadWebviewWithString:self.article1TF.text andWebview:self.article1WV];
}

- (IBAction) article2Tapped:(id)sender
{
    [self loadWebviewWithString:self.article2TF.text andWebview:self.article2WV];
}

- (IBAction)analyzeTapped:(id)sender
{
    [self compareNegativeWords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
