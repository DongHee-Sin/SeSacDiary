//
//  SearchImageViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit



protocol RegisterImageDelegate {
    func registerImage(urlString: String)
    
    func registerImage(image: UIImage)
}



class SearchImageViewController: BaseViewController {
    
    // MARK: - Propertys
    var imageURLList: [String] = []
    
    var selectedIndexPath: IndexPath?
    
    var selectedImage: UIImage?

    
    var delegate: RegisterImageDelegate?
    
    
    
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
        searchImageView.imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        searchImageView.imageCollectionView.keyboardDismissMode = .onDrag
    }
    
    
    override func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .darkGray
        
        let selectButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectImageButtonTapped))
        navigationItem.rightBarButtonItem = selectButton
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = closeButton
        
        setSearchController()
    }
    
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
    
    
    @objc func selectImageButtonTapped() {
        
        // 1. URL String
//        if let selectedIndexPath = selectedIndexPath {
//            delegate?.registerImage(urlString: imageURLList[selectedIndexPath.item])
//            dismiss(animated: true)
//        }else {
//            showAlertMessage(title: "선택된 이미지가 없습니다.", button: "확인")
//        }
        
        // 2. UIimage
        if let selectedImage = selectedImage {
            delegate?.registerImage(image: selectedImage)
            dismiss(animated: true)
        }else {
            showAlertMessage(title: "선택된 이미지가 없습니다.")
        }
    }
    
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
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
        
        cell.updateCell(imageURL: imageURLList[indexPath.item], isSelectedItem: selectedIndexPath == indexPath)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 1. URL String
//        let previouslySelected = selectedIndexPath
//        selectedIndexPath = indexPath
//
//        if let previouslySelected = previouslySelected {
//            searchImageView.imageCollectionView.reloadItems(at: [indexPath, previouslySelected])
//        }else {
//            searchImageView.imageCollectionView.reloadItems(at: [indexPath])
//        }
        
        // 2. UIimage
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }
        
        selectedImage = cell.searchResultImageView.image
        
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    
    
    // didDeselectItemAt 선택 해제 ⭐️
    // 다시 누르면 Border 없어지도록 해결해보기
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        selectedIndexPath = nil
//        selectedImage = nil
//        collectionView.reloadData()
//    }
}




// MARK: - SearchBar Protocol
extension SearchImageViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        selectedIndexPath = nil
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
