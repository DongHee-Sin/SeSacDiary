//
//  HomeViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/22.
//

import UIKit

import SnapKit
import RealmSwift // Realm 1. import
import FSCalendar


final class HomeViewController: BaseViewController {

    // MARK: - Propertys
    let repository = UserDiaryRepository()
    
    var tasks: Results<UserDiary>!
    
    var notificationToken: NotificationToken?
    
    let dateFormatterManager = DateFormatterManager.shared
    
    
    
    
    // MARK: - Life Cycle
    let homeView = HomeView()
    override func loadView() {
        self.view = homeView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realm 데이터베이스에 대한 Observe 등록
        // 데이터베이스의 값이 변경될 때 TableView reload를 실행하도록 구현
        let realm = try! Realm()
        let results = realm.objects(UserDiary.self)
        notificationToken = results.observe { [weak self] _ in
            self?.homeView.tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
        fetchRealm()
    }
    
    
    
    
    // MARK: - Methods
    func fetchRealm() {
        // Realm 3. Realm 데이터를 정렬하여 tasks에 담기
        tasks = repository.fetch()
    }
    
    
    override func configure() {
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        homeView.calendar.delegate = self
        homeView.calendar.dataSource = self
    }

    
    override func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .darkGray
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonTapped))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonTapped))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        navigationItem.leftBarButtonItems = [sortButton, filterButton]
        
        navigationItem.rightBarButtonItem = plusButton
    }
    
    
    // BarButtonAction
    @objc func sortButtonTapped() {
        tasks = repository.fetchSort("regdate")
    }
    
    @objc func filterButtonTapped() {
        tasks = repository.fetchFilter()
    }
    
    @objc func plusButtonTapped() {
        let vc = DiaryViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
    }
}




// MARK: - TableView Protocol
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.updateCell(data: tasks[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    // 편집 가능 여부를 반환
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    
    // 편집 스타일 (editingStyle)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // ⚠️ 오류 원인 : Realm Database의 값이 제거된 후, tasks(Results<UserDiary>) 프로퍼티에 설정했던 didSet 메서드가 호출되지 않음
            // didSet에 정의한 TableView reload가 호출되지 않으면서, 데이터베이스에서는 값이 지워졌음에도 불구하고 UI에는 데이터가 그대로 보여짐
            // 이 상황에서 스크롤링을 하거나 다시 Cell을 제거하는 동작을 취하면, 존재하지 않는 데이터에 접근하므로 Index 오류가 발생한 것.
            // 💡 오류 해결 : 테이블 프로퍼티(tasks)에 설정했던 didSet을 제거하고, Realm객체에 Observe 등록
            // https://www.mongodb.com/docs/realm/sdk/swift/react-to-changes/#std-label-ios-react-to-changes
            repository.delete(item: tasks[indexPath.row])
            
            
            // 1.
            // Document의 이미지를 먼저 삭제해줘야 한다!
//            removeImageFromDocument(fileName: "\(item.objectId).jpg")
//
//            try! localRealm.write {
//                localRealm.delete(item)
//            }
            
            
            // 2. 상수로 잠시 저장해둔 후 사용 (삭제할 데이터를)
            // 아래 코드는 오류남 (taskToDelete 상수는 원본값의 참조를 저장하기 때문 - 클래스)
//            let taskToDelete = tasks[indexPath.row]
//
//            try! localRealm.write {
//                localRealm.delete(taskToDelete)
//            }
//
//            removeImageFromDocument(fileName: "\(taskToDelete.objectId).jpg")
            
            //fetchRealm()
        }
    }
    
    
    
    // TableView Swipe
    // 참고. TableView Editing Mode
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Cell 높이가 충분하지 않으면 title이 잘릴 수 있음 (이미지랑 타이틀 모두 부여하는 경우)
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            // Realm Data Update
            let task = self.tasks[indexPath.row]
            self.repository.updateFavorite(item: task)
            
            // 업데이트 방법
            // 1. 스와이프한 셀 하나만 ReloadRows 구현           -> 상대적으로 효율적
            // 2. 데이터가 변경되었으니 다시 realm에서 데이터 가져오기 -> didSet 일관적 형태로 갱신
            //self.fetchRealm() -> 안써도 괜찮지만, 쓴다고 큰 부담이 되는건 아님
        }
        
        // Realm 데이터 기준으로 분기처리 해보기
        let imageString = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: imageString)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}




// MARK: - FSCalendar Protocol
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 10    // 최대 3개까지만 화면에 보임
    }
    
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "SeSac"
//    }
    
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star.fill")
//    }

    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        <#code#>
//    }
    

    // date: yyyyMMdd hh:mm:ss => dateFormatter 활용
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return dateFormatterManager.dateToString(date: date) == "22년 09월 07일" ? "오프라인 행사" : nil
    }


    // 날짜가 선택되면, 해당 날짜에 맞는 데이터만 필터링해서 보여주도록 구현하기
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(date: date)
    }
}
