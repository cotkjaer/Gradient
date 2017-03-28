//
//  TableViewController.swift
//  Gradient
//
//  Created by Christian Otkjær on 28/03/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController
{

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 12
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = "\(indexPath.section) x \(indexPath.row)"
        
        return cell
    }
}
