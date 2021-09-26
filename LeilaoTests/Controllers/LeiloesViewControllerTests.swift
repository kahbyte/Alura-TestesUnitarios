//
//  LeiloesViewControllerTests.swift
//  LeilaoTests
//
//  Created by Kauê Sales on 26/09/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class LeiloesViewControllerTests: XCTestCase {
    var sut: LeiloesViewController!
    var tableView: UITableView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! LeiloesViewController)
        
        _ = sut.view
        tableView = sut.tableView
        tableView.dataSource = sut
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableViewNaoDeveEstarNilAposViewDidLoad() {
        _ = sut.view
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func testDataSourceDaTableViewNaoDeveSerNil() {
        _ = sut.view
        
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.dataSource is LeiloesViewController)
    }
    
    func testNumberOfRowsInSectionDeveSerQuantidadeDeLeiloesDaLista() {
        
        sut.addLeilao(Leilao(descricao: "Playstation 4"))
        XCTAssertEqual(1, tableView.numberOfRows(inSection: 0))
        sut.addLeilao(Leilao(descricao: "iPhone 13"))
        tableView.reloadData()
        XCTAssertEqual(2, tableView.numberOfRows(inSection: 0))
    }
    
    func testCellForRowDeveRetornarLeilaoTableViewCell() {
        sut.addLeilao(Leilao(descricao: "TV Led"))
        
        tableView.reloadData()
        
        let celula = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(celula is LeilaoTableViewCell)
    }
    
    func testCellForRowDeveChamarDequeueReusableCell() {
        let mockTableView = MockTableView()
        mockTableView.dataSource = sut
        
        mockTableView.register(LeilaoTableViewCell.self, forCellReuseIdentifier: "LeilaoTableViewCell")
        
        sut.addLeilao(Leilao(descricao: "Macbook Pro 2019"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.celulaFoiReutilizada)
    }
}

extension LeiloesViewControllerTests {
    class MockTableView: UITableView {
        var celulaFoiReutilizada = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            celulaFoiReutilizada = true
            return super.dequeueReusableCell(withIdentifier: "LeilaoTableViewCell", for: indexPath)
        }
    }
}
