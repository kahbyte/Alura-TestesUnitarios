//
//  LeiloesViewController.swift
//  Leilao
//
//  Created by Kauê Sales on 26/09/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class LeiloesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listaDeLeiloes: [Leilao] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addLeilao(_ leilao: Leilao) {
        listaDeLeiloes.append(leilao)
    }
    
}

extension LeiloesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDeLeiloes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "LeilaoTableViewCell", for: indexPath)
    }
}
