//
//  EncerradorDeLeilaoTests.swift
//  LeilaoTests
//
//  Created by Kauê Sales on 18/09/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
import Cuckoo
@testable import Leilao

class EncerradorDeLeilaoTests: XCTestCase {
    
    var formatador: DateFormatter!
    var encerrador: EncerradorDeLeilao!
    var daoMock: MockLeilaoDao!
    var carteiroMock: MockCarteiro!

    override func setUpWithError() throws {
        formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd"
        daoMock = MockLeilaoDao().withEnabledSuperclassSpy()
        carteiroMock = MockCarteiro().withEnabledSuperclassSpy()
        encerrador = EncerradorDeLeilao(daoMock, Carteiro())
    }

    override func tearDownWithError() throws {
        
    }
    
    func testDeveEncerrarLeiloesQueComecaramUmaSemanaAntes() {
        guard let dataAntiga = formatador.date(from: "2021/09/07") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        
        stub(daoMock) { daoMock in
            when(daoMock.correntes()).thenReturn([tvLed, geladeira])
        }
        
        encerrador.encerra()
        
        guard let statusTvLed = tvLed.isEncerrado() else { return }
        
        guard let statusGeladeira = geladeira.isEncerrado() else { return }
        
        XCTAssertEqual(2, encerrador.getTotalEncerrados())
        XCTAssertTrue(statusTvLed)
        XCTAssertTrue(statusGeladeira)
    }
    
    func testDeveAtualizarLeiloesEncerrados() {
        guard let dataAntiga = formatador.date(from: "2020/09/07") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        
        
        stub(daoMock) { daoMock in
            when(daoMock.correntes()).thenReturn([tvLed])
        }
        
        encerrador.encerra()
        
        verify(daoMock).atualiza(leilao: tvLed)
    }
    
    func testDeveContinuarAExecucaoMesmoQuandoDaoFalha() {
        guard let dataAntiga = formatador.date(from: "2020/09/07") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        
        stub(daoMock) { daoMock in
            when(daoMock.correntes()).thenReturn([tvLed, geladeira])
            when(daoMock.atualiza(leilao: tvLed)).thenThrow(error)
        }
        
        encerrador.encerra()
        verify(daoMock).atualiza(leilao: geladeira)
//        verify(carteiroMock).envia(geladeira)
    }

}

extension Leilao: Matchable {
    public var matcher: ParameterMatcher<Leilao> {
        return equal(to: self)
    }
}
