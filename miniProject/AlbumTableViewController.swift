//
//  AlbumTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    var album = AlbumSeed().album
    
   
    @IBAction func addAlbum(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController")
        navigationController?.pushViewController(pushViewController, animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumTableViewCell
        cell.albumTitle.text = album[indexPath.row].travelName
        cell.albumMessage.text = "\(album[indexPath.row].time) | \(album[indexPath.row].day) day"
        cell.albumTitleImage.image = UIImage(named: album[indexPath.row].titleImage)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let segue = segue.destination as! MapViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                segue.photoDataModel = album[indexPath.row].photos
                
            }
        }
      }
   }
