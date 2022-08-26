//
//  RealmModel.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/22.
//

import Foundation
import RealmSwift


// <테이블에 대한 스키마 정의>


// UserDiary : 테이블 이름
// Persisted : 컬럼
class UserDiary: Object {
    @Persisted var diaryTitle: String     // 제목(필수)
    @Persisted var diaryContent: String?  // 내용(옵션)
    @Persisted var diaryDate: Date        // 작성 날짜(필수)
    @Persisted var regdate: Date          // 등록 날짜(필수)
    @Persisted var favorite: Bool         // 즐겨찾기(필수)
    @Persisted var photoURL: String?      // 사진 URL String(옵션)
    
    // PrimaryKey(필수) : Int, UUID, ObjectID 데이터타입을 주로 사용
    // Realm에서는 UUID, ObjectID를 권장 -> realm에서 랜덤으로 뽑아준다
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    
    // Thread 1: "Attempting to create an object of type 'UserDiary' with an existing primary key value '0'."
    // PK가 중복되서 발생하는 오류 (Int로 PK를 설정했다면, 계속 숫자를 올려줘야되는데, 안올려줘서 발생하는 오류)
    
    
    convenience init(diaryTitle: String, diaryContent: String?, diaryDate: Date, regdate: Date, photoURL: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryDate = diaryDate
        self.regdate = regdate
        self.favorite = false
        self.photoURL = photoURL
    }
}
