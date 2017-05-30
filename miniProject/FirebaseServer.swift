//
//  FirebaseServer.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/5/29.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import GoogleMaps


class FirebaseServer {
    
    private static var FirebaseModel:FirebaseServer?
    
    static func firebase() -> FirebaseServer {
        if FirebaseModel == nil {
            FirebaseModel = FirebaseServer()
        }
        return FirebaseModel!
    }
    
    private init() {
        album = []
    }
    
    private var album:[Album]
    private let UserRef = Database.database().reference().child("User")
    private let albumRef = Database.database().reference().child("Album")
    
    func checkUserGetAlbum(getType: DataEventType, completion: () -> ()) {
        self.UserRef.observe(.value, with: { (snapshot) in
            if let userDict = snapshot.value as? [String: AnyObject] {
                for i in 0..<userDict.count {
                    if Array(userDict.keys)[i] == Auth.auth().currentUser?.uid {
                        if let getTheAlbumId = Array(userDict.values)[i] as? [String: AnyObject] {
                            if let albumID = getTheAlbumId["participateAlbum"] as? [String:String] {
                                for x in 0..<albumID.count {
                                    self.getAlbumData(getType: getType, albumId: Array(albumID.keys)[x])
                                }
                            }
                        }
                    }
                }
            }
        })
    }

    private func getAlbumData(getType: DataEventType, albumId:String) {
        var loadAlbumModel = Album(key: String(), travelName: String(), startDate: Double(), endDate: Double(), titleImage: UIImage(), photos: [PhotoDataModel]())
        
        albumRef.observe(getType, with: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject] {
                for i in 0..<dict.count {
                    if Array(dict.keys)[i] == albumId {
                        if let getDetail = Array(dict.values)[i] as? [String:AnyObject] {
                            let albumKey = Array(dict.keys)[i]
                            let name = getDetail["travelName"] as? String
                            let startDate = getDetail["startDate"] as? Double
                            let endDate = getDetail["endDate"] as? Double
                            let titleImage = getDetail["image"] as? String
                            let photoRef = self.albumRef.child(albumKey).child("photos")
                            let photoDataArray = self.getPhotoData(photoRef: photoRef, albumId: albumKey, getType: getType)
                            let titleImageURL = URL(string: titleImage!)
                            do {
                                let data = try Data(contentsOf: titleImageURL!)
                                let picture = UIImage(data: data)
                                loadAlbumModel = Album(key: albumKey, travelName: name!, startDate: startDate!, endDate: endDate!, titleImage: picture!, photos: photoDataArray)
                            } catch {
                                
                            }
                            self.album.append(loadAlbumModel)
                        }
                    }
                }
            }
        })
    }
    
    private func getPhotoData(photoRef: DatabaseReference, albumId:String, getType: DataEventType) -> [PhotoDataModel] {
        var photoDataArray:[PhotoDataModel]?
        var loadPhotoModel = PhotoDataModel(albumID: String(), photoID: String(), photoName: [String](), picturesDay: String(), coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(), longitude: CLLocationDegrees()))
        photoRef.observe(getType, with: { (snapshot) in
            if let photodict = snapshot.value as? [String: AnyObject] {
                for i in 0..<photodict.count {
                    if let getPhotoDetail = Array(photodict.values)[i] as? [String: AnyObject] {
                        let key = Array(getPhotoDetail.keys)[i]
                        let photoName = getPhotoDetail["photoName"] as? Array<String>
                        let day = getPhotoDetail["day"] as? String
                        let latitude = getPhotoDetail["latitude"] as? Double
                        let longitude = getPhotoDetail["longitude"] as? Double
                        loadPhotoModel = PhotoDataModel(albumID: albumId, photoID: key, photoName: photoName!, picturesDay: day!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
                        
                        for i in self.album {
                            if loadPhotoModel.albumID == i.key {
                                i.photos.append(loadPhotoModel)
                            }
                        }
                    }
                }
                
            }
        })
    }
    
}
