//
//  ImageCollectionViewController.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import UIKit

final class ImageCollectionViewController: UIViewController {
    // MARK: - Enum
    private enum Section {
        case all
    }
    
    // MARK: - UI properties
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Instance properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, ImageCellViewModel>?
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ImageCellViewModel>?
    private var imageRepo = ImageRepo(networkManager: NetworkManager())
    private var images: [Image] = []
    private var imageCellViewModels: [ImageCellViewModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    private var searchTextDisplayed = ""
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        debouncer.delegate = self
    }
    
    // MARK: - View helper methods
    private func setupView() {
        view.backgroundColor = .white
        
        // setup navigation bar
        navigationItem.title = "Images"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UICollectionView helper methods
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(130))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
    
    private func createDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, ImageCellViewModel>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, viewModel) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
                    return UICollectionViewCell()
                }
                
                cell.viewModel = viewModel
                return cell
            })
    }
    
    private func updateUI() {
        guard let dataSource = dataSource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageCellViewModel>()
        snapshot.appendSections([.all])
        snapshot.appendItems(imageCellViewModels, toSection: .all)
        
        dataSource.apply(snapshot)
        
        self.snapshot = snapshot
    }
    
    // MARK: - Network call methods
    private func getImages(with text: String) {
        images.removeAll()
        imageCellViewModels.removeAll()
        
        guard text != "" else { return }
        imageRepo.fetchImages(with: text) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let images):
                    let viewModels = images.map { ImageCellViewModel(with: $0) }
                    self.images.append(contentsOf: images)
                    self.imageCellViewModels.append(contentsOf: viewModels)
                    self.createDataSource()
                    self.updateUI()
                case .failure(let error):
                    // TODO: - Handle error
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension ImageCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debouncer.call()
    }
}

// MARK: - DebouncerDelegate
extension ImageCollectionViewController: DebouncerDelegate {
    func didFireDebouncer(_ debouncer: Debouncer) {
        guard let searchText = searchController.searchBar.text,
              searchText != searchTextDisplayed else {
            return
        }
        searchTextDisplayed = searchText
        getImages(with: searchText)
    }
}
    }
}
