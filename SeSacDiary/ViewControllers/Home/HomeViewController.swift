//
//  HomeViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift // Realm 1. import

class HomeViewController: BaseViewController {

    // MARK: - Propertys
    let localRealm = try! Realm()  // Realm 2.
    
    var tasks: Results<UserDiary>! {
        didSet {
            homeView.tableView.reloadData()
        }
    }
    
    
    
    
    // MARK: - Life Cycle
    let homeView = HomeView()
    override func loadView() {
        self.view = homeView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRealm()
    }
    
    
    
    
    // MARK: - Methods
    func fetchRealm() {
        // Realm 3. Realm 데이터를 정렬하여 tasks에 담기
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    
    override func configure() {
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "regdate", ascending: true)
    }
    
    @objc func filterButtonTapped() {
        //
    }
    
    @objc func plusButtonTapped() {
        let vc = DiaryViewController()
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
    
}




// MARK: - TableView Protocol
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].diaryTitle
        return cell
    }
    
    
    // TableView Swipe
    // 참고. TableView Editing Mode
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Cell 높이가 충분하지 않으면 title이 잘릴 수 있음 (이미지랑 타이틀 모두 부여하는 경우)
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            // Realm Data Update
            try! self.localRealm.write{
                // 하나의 데이터만 변경
                //self.tasks[indexPath.row].favorite.toggle()
                                
                // 하나의 테이블의 특정 컬럼 전체 값을 변경
                //self.tasks.setValue(true, forKey: "favorite")
                                
                // 하나의 레코드의 여러 컬럼값을 변경
                //self.localRealm.create(UserDiary.self, value: ["objectID": self.tasks[indexPath.row].objectId, "diaryTitle": "제목임"], update: .modified)
                
                print("ReloadRow 필요")
            }
            
            // 업데이트 방법
            // 1. 스와이프한 셀 하나만 ReloadRows 구현           -> 상대적으로 효율적
            // 2. 데이터가 변경되었으니 다시 realm에서 데이터 가져오기 -> didSet 일관적 형태로 갱신
            self.fetchRealm()
        }
        
        // Realm 데이터 기준으로 분기처리 해보기
        let imageString = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: imageString)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}
