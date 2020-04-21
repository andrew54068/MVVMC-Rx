//
//  CollectionListViewController.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import RxDataSources
import RxSwift

struct CellModel: SectionModelType {
    typealias Item = CollectionModel
    var items: [Item]

    init(items: [CollectionModel]) {
        self.items = items
    }

    init(original: CellModel, items: [CollectionModel]) {
        self = original
        self.items = items
    }
}

final class CollectionListViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.itemSize = .init(width: (UIScreen.main.bounds.width - 30) / 2, height: 200)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .init(width: view.bounds.width, height: 50)
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.registerCell(type: cellType)
        collectionView.registerSectionFooter(type: footerType)
        return collectionView
    }()

    private let viewModel: CollectionListViewModel

    private var cellType: CollectionListCollectionViewCell.Type { CollectionListCollectionViewCell.self }
    private var footerType: CollectionListFooter.Type { CollectionListFooter.self }

    private let dataSource = RxCollectionViewSectionedReloadDataSource<CellModel>.init(
        configureCell: { (dataSource, collectionView, indexPath, model) -> UICollectionViewCell in
            let cell: CollectionListCollectionViewCell = collectionView.dequeueReusableCell(with: CollectionListCollectionViewCell.self, for: indexPath)
            cell.setup(model: model)
            return cell
    }, configureSupplementaryView: { (dataSource, collectionView, string, indexPath) -> UICollectionReusableView in
        if string == UICollectionView.elementKindSectionFooter {
            let footer: CollectionListFooter = collectionView.dequeueReusableSectionFooter(with: CollectionListFooter.self, for: indexPath)
            return footer
        } else {
            return UICollectionReusableView()
        }
    })

    private let bag: DisposeBag = DisposeBag()

    init(viewModel: CollectionListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupNavigation()

        viewModel.fetchFirst()
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

    private func setupBindings() {

        viewModel.balance
            .subscribe(onNext: { [weak self] balance in
                self?.title = balance
                })
            .disposed(by: bag)

        viewModel.loading
            .bind(to: rx.isLoading)
            .disposed(by: bag)

        viewModel.error
            .subscribe { error in
                let alert = UIAlertController(title: "Error",
                                              message: error.debugDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
        .disposed(by: bag)


        collectionView.rx
            .modelSelected(CollectionModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.viewModel.present(with: model)
            })
            .disposed(by: bag)

        Observable
            .zip(collectionView.rx.prefetchItems, viewModel.models)
            .bind { indexPaths, models in
                let urls: [URL] = indexPaths.compactMap {
                    if models.count > $0.item {
                        return models[$0.item].imageUrl
                    } else {
                        return nil
                    }
                }
                SDWebImagePrefetcher.shared.prefetchURLs(urls)
            }
        .disposed(by: bag)

        collectionView.rx
            .willDisplaySupplementaryView
            .filter({ (_, elementKind, _) -> Bool in
                return elementKind == UICollectionView.elementKindSectionFooter
            })
            .withLatestFrom(viewModel.loadingMore)
            .filter { !$0 }
            .withLatestFrom(viewModel.models)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.loadMore()
            })
            .disposed(by: bag)

        viewModel.models
            .map { [CellModel(items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

    }

    private func setupNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "list", style: .plain, target: self, action: nil)
    }
}
