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


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUpWebViews];

    
}

-(void)viewWillAppear:(BOOL)animated {
    NSString *string = @"He used to like swimming";
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: [NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:options];
    
    tagger.string = string;
    
    [tagger enumerateTagsInRange:NSMakeRange(0, [string length])
                          scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass
                         options:options
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
     {
         NSString *token = [string substringWithRange:tokenRange];
         
     }];
    
    [tagger enumerateTagsInRange:NSMakeRange(0, [string length])
                          scheme:NSLinguisticTagSchemeLemma
                         options:options
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
     {
         NSString *aToken = [string substringWithRange:tokenRange];
         NSLog(@"%@ : %@", aToken, tag);
     }];
}

- (void) processNaturalLanguageWithString: (NSString *)string
{
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: @[[NSLinguisticTagger availableTagSchemesForLanguage:@"en"], NSLinguisticTagSchemeLemma] options:options];
    
    tagger.string = string;
    
    [tagger enumerateTagsInRange:NSMakeRange(0, [string length])
                          scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass
                         options:options
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                          
                          NSString *token = [string substringWithRange:tokenRange];
                          
                          NSLog(@"%@: %@", token, tag);
                      }];
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
    return @[@"scrutinize", @"dishearten", @"bad",  ];
}

- (void)setUpWebViews {
//    
//    self.article1WV.delegate = self;
//    self.article2WV.delegate = self;
    
    [self getArticleWithString:@"http://google.com" andWebview:self.article1WV];
    [self getArticleWithString:@"http://yahoo.com" andWebview:self.article2WV];
}

- (void)getArticleWithString:(NSString *)string andWebview:(UIWebView *)webView {
    NSString *urlString = string;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}



- (NSString *) getHTMLStringVersionOfArticleWithString: (NSString *)string {
    NSURL *googleURL = [NSURL URLWithString:string];
    NSError *error;
    NSString *htmlPage = [NSString stringWithContentsOfURL:googleURL
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    
    return htmlPage;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
