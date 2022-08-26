//
//  UserDiaryRepository.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/26.
//

import Foundation
import RealmSwift


// 프로토콜을 보고 어떤 기능이 구현되어 있을지 한눈에 확인 가능
protocol UserDiaryRepositoryType {
    func fetch() -> Results<UserDiary>
    func fetchSort(_ sort: String) -> Results<UserDiary>
    func fetchFilter() -> Results<UserDiary>
    func fetchDate(date: Date) -> Results<UserDiary>
    func updateFavorite(item: UserDiary)
    func delete(item: UserDiary)
    func addItem(item: UserDiary)
}


// Repository를 구조체로 만들어도 크게 문제는 없다.
class UserDiaryRepository: UserDiaryRepositoryType {
    
    // Realm은 구조체!
    // 근데, Realm 구조체의 인스턴스를 여러곳에서 만들더라도, 결과적으로 같은곳을 본다..
    // 메모리 주소가 다른 여러개의 인스턴스가 있더라도 내부적인 구현으로 결국 같은 곳을 본다는..?
    let localRealm = try! Realm()
    
    
    func fetch() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    
    // 열거형 + 원시값으로 개선해봐도 좋을듯
    func fetchSort(_ sort: String) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    
    func fetchFilter() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] 'a'")
    }
    
    
    func fetchDate(date: Date) -> Results<UserDiary> {
        // NSPredicate
        // 약간 C언어에서 처럼 %@라는곳에 넣을 값을 뒤에 순서대로 입력해준다. 
        localRealm.objects(UserDiary.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date))
    }
    
    
    func updateFavorite(item: UserDiary) {
        try! localRealm.write{
            // 하나의 데이터만 변경
            item.favorite.toggle()
                            
            // 하나의 테이블의 특정 컬럼 전체 값을 변경
            //self.tasks.setValue(true, forKey: "favorite")
                            
            // 하나의 레코드의 여러 컬럼값을 변경
            //self.localRealm.create(UserDiary.self, value: ["objectID": self.tasks[indexPath.row].objectId, "diaryTitle": "제목임"], update: .modified)
            
            print("ReloadRow 필요")
        }
    }
    
    
    func delete(item: UserDiary) {
        removeImageFromDocument(fileName: "\(item.objectId).jpg")

        try! localRealm.write {
            localRealm.delete(item)
        }
    }
    
    
    func addItem(item: UserDiary) {
        //
    }
    
    
    // 도큐먼트에 있는 이미지 제거하는 메서드
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        }catch let error {
            print(error)
        }
    }
}
