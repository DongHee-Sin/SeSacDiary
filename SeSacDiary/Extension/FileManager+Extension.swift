//
//  FileManager+Extension.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit


extension UIViewController {
    
    // 이미지 가져오는 메서드 (도큐먼트에서)
    func loadImageFromDocument(fileName: String) -> UIImage? {
        // Document 경로 가져오는 코드
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        // 세부 파일 경로 (이미지를 저장할 경로)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 파일이 있는지? 확인하는 코드
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)   // .path : URL타입을 문자열로 바꿔주는 코드
        }else {
            return UIImage(systemName: "star.fill")
        }
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
    
    
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        // Document 경로 가져오는 코드
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 세부 파일 경로 (이미지를 저장할 경로)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error: \(error)")
        }
    }
}
