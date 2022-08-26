//
//  FileManager+Extension.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit


extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    
    
    // 이미지 가져오는 메서드 (도큐먼트에서)
    func loadImageFromDocument(fileName: String) -> UIImage? {
        // Document 경로 가져오는 코드
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        // 세부 파일 경로 (이미지를 저장할 경로)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 파일이 있는지? 확인하는 코드
        // .path : URL타입을 문자열로 바꿔주는 코드
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }else {
            return UIImage(systemName: "star.fill")
        }
    }

    
    
    
    // Document에 저장된 zip 확장자 파일 리스트 확인
    func fetchDocumentZipFile() {
        do {
            guard let path = documentDirectoryPath() else { return }
            
            // Document에 포함된 모든 파일의 URL을 가져온다.
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("docs: \(docs)")
            
            // Document에 포함된 파일 중, 확장자(pathExtension)가 zip인 파일의 URL만 filter 한다.
            let zip = docs.filter { $0.pathExtension == "zip" }
            print("zip: \(zip)")
            
            // URL의 마지막 경로(여기서는 파일 이름과 확장자)만 뽑아서 매핑한다.
            let result = zip.map { $0.lastPathComponent }
            print("result: \(result)")
            
        }catch {
            print("ERROR")
        }
        
    }
}
