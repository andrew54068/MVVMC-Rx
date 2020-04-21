//
//  MVVMC_RxTests.swift
//  MVVMC+RxTests
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import XCTest
import RxSwift
@testable import MVVMC_Rx

class MVVMC_RxTests: XCTestCase {

    private var interactor: ListFakeInteractor!
    private var coordinator: ListFakeCoordinator!
    private var viewModel: CollectionListViewModel!

    private let bag: DisposeBag = .init()

    override func setUp() {
        super.setUp()

        interactor = ListFakeInteractor()
        coordinator = ListFakeCoordinator()
        viewModel = CollectionListViewModel(interactor: interactor, coordinator: coordinator)
    }

    override func tearDown() {
        interactor = nil
        coordinator = nil
        viewModel = nil
        super.tearDown()
    }

    func testViewModelFetchAssets() {
        let exp = expectation(description: "Fetch groups")

        // This completion block should be called when groups are fetched
        interactor.fetchAssets(page: 0)
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                if case let .next(models) = event {
                    XCTAssert(models.count == 2, "models count should be 2 but find \(models.count) instead.")
                    XCTAssert(models[0].tokenId == "first", "first model tokenId should be \"first\" but find \(models[0].tokenId) instead.")
                    XCTAssert(models[0].name == "name1", "first model name should be \"name1\" but find \(models[0].name) instead.")
                    XCTAssert(models[0].collectionName == "collectionName1", "first model name should be \"collectionName1\" but find \(models[0].collectionName) instead.")

                    XCTAssert(models[1].tokenId == "second", "second model tokenId should be \"second\" but find \(models[1].tokenId) instead.")
                    XCTAssert(models[1].name == "name2", "first model name should be \"name2\" but find \(models[1].name) instead.")
                    XCTAssert(models[1].collectionName == "collectionName2", "first model name should be \"collectionName2\" but find \(models[0].collectionName) instead.")
                    exp.fulfill()
                }
            })
            .disposed(by: bag)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testViewModelGetBalance() {
        let exp = expectation(description: "Fetch groups")

        // This completion block should be called when groups are fetched
        interactor.getBalance()
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                if case let .next(balance) = event {
                    XCTAssert(balance == "123.456", "balance should be \"123.456\" but find \(balance) instead.")
                    exp.fulfill()
                }
            })
            .disposed(by: bag)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

}

// MARK: Mocked interactor

class ListFakeInteractor: CollectionListInteractorProtocol {

    func fetchAssets(page: Int) -> Observable<[CollectionModel]> {
        return Observable<[CollectionModel]>.just([
            CollectionModel(tokenId: "first",
                            name: "name1",
                            collectionName: "collectionName1"),
            CollectionModel(tokenId: "second",
                            name: "name2",
                            collectionName: "collectionName2"),
        ])
    }

    func getBalance() -> Observable<String> {
        return Observable<String>.just("123.456")
    }

}

// MARK: Mocked coordinator

class ListFakeCoordinator: CollectionListCoordinatorProtocol {

    var navigator: UINavigationController?

    func navigate(with model: CollectionModel) {

    }

}
