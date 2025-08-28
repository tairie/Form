//
//  FORMSignedNumberInputValidator.m
//  Tests
//
//  Created by Takashi Irie on 2025/08/28.
//

#import "FORMSignedNumberInputValidator.h"

@implementation FORMSignedNumberInputValidator

// 先頭の負号を1個だけ許容
// 小数点は不可（整数のみ）
// 貼り付け（例: -123 を一気にペースト）にも対応

- (BOOL)validateReplacementString:(NSString *)string
                         withText:(NSString *)text
                        withRange:(NSRange)range
{
    // 親の汎用チェック（長さ、コピーガード等がある場合）
    BOOL ok = [super validateReplacementString:string withText:text withRange:range];
    if (!ok) return NO;
    
    // 削除（バックスペース）は常に許可
    if (string.length == 0) return YES;
    
    // 置換後文字列（ペーストや複数文字にも対応）
    NSString *newText = [text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length == 0) return YES;
    
    // 数字集合
    static NSCharacterSet *digits;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        digits = [NSCharacterSet decimalDigitCharacterSet];
    });
    
    // 1) 「-」(U+002D) または「−」(U+2212) のみは編集中の一時状態として許容
    if ([newText isEqualToString:@"-"] || [newText isEqualToString:@"\u2212"]) {
        return YES;
    }
    
    // 2) 先頭が負号なら外して残りを検証（負号は1回だけ・先頭のみ）
    if ([newText hasPrefix:@"-"] || [newText hasPrefix:@"\u2212"]) {
        NSString *rest = [newText substringFromIndex:1];
        
        // 残りに追加の負号が含まれていないこと
        if ([rest containsString:@"-"] || [rest containsString:@"\u2212"]) return NO;
        
        // 残りはすべて数字
        NSCharacterSet *restSet = [NSCharacterSet characterSetWithCharactersInString:rest];
        return [digits isSupersetOfSet:restSet];
    }
    
    // 3) 通常は全体が数字のみ
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:newText];
    return [digits isSupersetOfSet:set];
}

@end
