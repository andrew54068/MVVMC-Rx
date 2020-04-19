//
//  CollectionListViewController.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CollectionListViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.itemSize = .init(width: (UIScreen.main.bounds.width - 30) / 2, height: 200)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private let viewModel: CollectionListViewModel

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
        viewModel.fetchData()
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
            .bind(to: self.rx.isLoading)
            .disposed(by: bag)

        let cellType: CollectionListCollectionViewCell.Type = CollectionListCollectionViewCell.self
        collectionView.registerCell(type: cellType)

        viewModel.models
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: cellType),
                                              cellType: cellType)) { _, model, cell in
                                                cell.setup(model: model)
        }
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

        Observable
            .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(CollectionModel.self))
            .bind { [weak self] indexPath, model in
                self?.viewModel.present(with: model)
        }
        .disposed(by: bag)

    }

    private func setupNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "list", style: .plain, target: self, action: nil)
    }
}
