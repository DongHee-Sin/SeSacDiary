//
//  SearchImageViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

class SearchImageViewController: BaseViewController {

    // MARK: - Propertys
    var imageURLList: [String] = []
    
    
    
    // MARK: - LoadView & ViewDidLoad
    let searchImageView = SearchImageView()
    
    override func loadView() {
        self.view = searchImageView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - Methods
    override func configure() {
        searchImageView.imageCollectionView.delegate = self
        searchImageView.imageCollectionView.dataSource = self
        searchImageView.imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    
    override func setNavigationBar() {
        let selectButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectImageButtonTapped))
        navigationItem.rightBarButtonItem = selectButton
        
        navigationController?.navigationBar.tintColor = .darkGray
        
        setSearchController()
    }
    
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
    
    
    @objc func selectImageButtonTapped() {
        print("선택")
    }
}




// MARK: - CollectionView Protocol
extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateCell(imageURL: imageURLList[indexPath.item])
        
        return cell
    }
}




// MARK: - SearchBar Protocol
extension SearchImageViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        imageURLList.removeAll()
        
        guard let query = searchBar.text else { return }
        
        APIManager.shared.requestAPI(query: query) { [weak self] json in
            guard let self = self else { return }
            
            json["results"].arrayValue.forEach { json in
                let url = json["urls"]["small"].stringValue
                self.imageURLList.append(url)
            }
            
            self.searchImageView.imageCollectionView.reloadData()
        }
    }
}
