//
//  GeradorDePagamentoTests.swift
//  LeilaoTests
//
//  Created by Kauê Sales on 20/09/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class GeradorDePagamentoTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testDeveGerarPagamentoParaUmLeilaoEncerrado() {
        let playstation = CriadorDeLeilao().para(descricao: "Playstation")
            .lance(Usuario(nome: "Jose"), 2000)
            .lance((Usuario(nome: "Maria")), 2500)
            .constroi()
        
        let daoMock = MockLeilaoDao().withEnabledSuperclassSpy()
        
        stub(daoMock) { daoMock in
            when(daoMock.encerrados()).thenReturn([playstation])
        }
        
        
    }

}
