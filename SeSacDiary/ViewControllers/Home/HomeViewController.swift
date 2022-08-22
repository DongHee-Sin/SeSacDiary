//
//  HomeViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift // Realm 1. import

class HomeViewController: UIViewController {

    let localRealm = try! Realm()  // Realm 2.
    
    let tableView: UITableView = {
       let view = UITableView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var tasks: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realm 3. Realm 데이터를 정렬하여 tasks에 담기
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(0)
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 갱신을 위해 데이터 다시 가져오기
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        
        // 갱신
        tableView.reloadData()
    }
    
    
    @objc func plusButtonTapped() {
        let vc = DiaryViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].diaryTitle
        return cell
    }
}
