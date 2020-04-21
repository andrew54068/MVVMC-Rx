//
//  CollectionDetailViewController.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/19.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import RxCocoa
import RxSwift

final class CollectionDetailViewController: UIViewController {

    let viewModel: CollectionDetailViewModel

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    private var desLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    private var linkButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitle("permalink", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .clear
        return button
    }()

    private let bag: DisposeBag = .init()

    init(viewModel: CollectionDetailViewModel) {
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
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(itemImageView)
        view.addSubview(nameLabel)
        view.addSubview(desLabel)
        view.addSubview(linkButton)

        itemImageView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            } else {
                make.top.left.equalTo(view.layoutMarginsGuide).offset(20)
            }
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(300)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }

        desLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }

        linkButton.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            } else {
                make.bottom.right.equalTo(view.layoutMarginsGuide).offset(-20)
            }
            make.left.equalTo(15)
            make.height.equalTo(30)
        }

    }

    private func setupBindings() {

        viewModel.modelObservable
            .subscribe(onNext: { [weak self] model in
                self?.itemImageView.sd_setImage(with: model.imageUrl) { (image, error, _, _) in
                    if error != nil || image == nil {
                        self?.itemImageView.image = UIImage(named: "notfound")
                    }
                }
                self?.nameLabel.text = model.name
                self?.desLabel.text = model.description
                self?.title = model.collectionName
            })
            .disposed(by: bag)

    }

}
