//
//  FORMSignedNumberInputValidator.h
//  Tests
//
//  Created by Takashi Irie on 2025/08/28.
//

#import "FORMInputValidator.h"

/// 負の整数も含めて入力できる signed_number 用バリデータ（小数点は不可）
@interface FORMSignedNumberInputValidator : FORMInputValidator

@end
