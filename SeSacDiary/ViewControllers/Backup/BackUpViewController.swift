//
//  BackUpViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit
import Zip

class BackUpViewController: BaseViewController {

    // MARK: - Propertys
    var backUpFiles: [String] = ["", ""]
    
    
    
    
    
    // MARK: - Life Cylce
    let backUpView = BackUpView()
    override func loadView() {
        self.view = backUpView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    // MARK: - Methods
    override func configure() {
        // TableView
        backUpView.backUpListTableView.delegate = self
        backUpView.backUpListTableView.dataSource = self
        backUpView.backUpListTableView.register(BackUpTableViewCell.self, forCellReuseIdentifier: BackUpTableViewCell.identifier)
        
        backUpView.coverView.isHidden = !backUpFiles.isEmpty
        
        backUpView.backUpButton.addTarget(self, action: #selector(addBackUpButtonTapped), for: .touchUpInside)
        backUpView.restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }
    
    
    // 백업
    @objc func addBackUpButtonTapped() {
        
        var urlPaths = [URL]()
        
        // 1. 도큐먼트 위치에 백업 파일이 있는지 확인
        guard let path = documentDirectoryPath() else {                      // Document 위치 가져오기
            showAlertMessage(title: "Document 위치에 오류가 있습니다.")
            return
        }
        
        let realmFile = path.appendingPathComponent("default.realm")         // realm 파일까지의 경로 저장
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {  // realm 파일이 존재하는지 확인
            showAlertMessage(title: "백업할 파일이 없습니다.")
            return
        }
        
        urlPaths.append(realmFile)                        // 미리 생성한 변수에 realm까지의 경로를 저장
        
        
        // 2. 백업 파일을 압축: URL 배열을 저장 (압축 링크)
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSacDiary_1")
            print("Archive Location: \(zipFilePath)")
            
            // 3. ActivityViewController 띄워주기
            showActivityViewController()
            
        } catch {
            showAlertMessage(title: "압축에 실패했습니다.")
        }
    }
    
    
    func showActivityViewController() {
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "Document 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("SeSacDiary_1.zip")
        
        // activityItems : 전달할 데이터
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        present(vc, animated: true)
    }
    
    
    // 복구
    @objc func restoreButtonTapped() {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker, animated: true)
    }
}




// MARK: - TableView Protocol
extension BackUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackUpTableViewCell.identifier, for: indexPath) as? BackUpTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}




// MARK: - DocumentPicker Protocol
extension BackUpViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // 1. 백업 파일 가져오기
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        // 2. 백업 파일을 저장할 경로 설정
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "Document 위치에 오류가 있습니다.")
            return
        }
        
        // 현재 Document Path에 백업했던 파일의 이름과 확장자 append
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            do {
                try Zip.unzipFile(sandboxFileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { [weak self] unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self?.showAlertMessage(title: "복구가 완료되었습니다.")
                })
            }catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        }else {
            
            do {
                // 파일 앱의 zip -> Document 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                try Zip.unzipFile(sandboxFileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { [weak self] unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self?.showAlertMessage(title: "복구가 완료되었습니다.")
                })
                
            }catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        }
    }
}
