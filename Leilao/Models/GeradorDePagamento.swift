//
//  GeradorDePagamento.swift
//  Leilao
//
//  Created by Kauê Sales on 20/09/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import Foundation

class GeradorDePagamento {
    private var leiloes: LeilaoDao
    private var avaliador: Avaliador
    private var repositorio: RepositorioDePagamento
    
    init(_ leiloes: LeilaoDao, _ avaliador: Avaliador, _ repositorio: RepositorioDePagamento) {
        self.leiloes = leiloes
        self.avaliador = avaliador
        self.repositorio = repositorio
    }
    
    func gera() {
        let leiloesEncerrados = self.leiloes.encerrados()
        
        for leilao in leiloesEncerrados {
            try? avaliador.avalia(leilao: leilao)
            
            let novoPagamento = Pagamento(avaliador.maiorLance(), Date())
            repositorio.salva(novoPagamento)
        }
    }
}
