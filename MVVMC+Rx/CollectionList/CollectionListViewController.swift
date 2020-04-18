//
//  CollectionListViewController.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import RxSwift

final class CollectionListViewController: UIViewController {

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
        setupBindings()
    }

    private func setupBindings() {
        let observer: Observable<[CollectionModel]> = viewModel.fetchData()
        observer.subscribe({ event in
            switch event {
            case let .next(models):
                print("success")
            case let .error(error):
                print(error)
            case .completed:
                print("complete")
            }
        }).disposed(by: bag)
    }
}
