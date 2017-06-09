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
    private var userData:UserModel?
    private var selectAlbumNumber:Int?
    private var selectPhotoNumber:Int?
    private let UserRef = Database.database().reference().child("User")
    private let albumRef = Database.database().reference().child("Album")
    private let photoRef = Database.database().reference().child("Photo")
    
    
    func getRefPath(getPath:String) -> DatabaseReference {
        var refPath:DatabaseReference?
        switch getPath {
        case "user":
            refPath = UserRef
        case "album":
            refPath = albumRef
        case "photo":
            refPath = photoRef
        default:
            break
        }
        return refPath!
    }
    
   
//  =============================AlbumData================================
    func getSelectAlbumData() -> Album {
        print(selectAlbumNumber)
        return album[selectAlbumNumber!]
    }
    
    func dataArrayCount() -> Int {
        return album.count
    }
    
    func dataArray(select:Int) -> Album {
        return album[select]
    }
    
    func saveSelectNumber(num:Int) {
        selectAlbumNumber = num
    }
    
//  =============================PhotoData================================
    func getPhotoArrayCount() -> Int {
        return album[selectAlbumNumber!].photos.count
    }
    
    func getPhotoArrayData(select:Int) -> PhotoDataModel {
        let photoArray = album[selectAlbumNumber!].photos
        return photoArray[select]
    }

    func saveSelectPhotoDataNum(num:Int, completion:() -> ()) {
        selectPhotoNumber = num
        completion()
    }
    
    func getPhotoId() -> String {
        return album[selectAlbumNumber!].photos[selectPhotoNumber!].photoID
        
    }
    
    func getSelectPhotoDataArray(selectPhoto:Int) -> String {
       return album[selectAlbumNumber!].photos[selectPhotoNumber!].photoName[selectPhoto]
    }
    
    func getSelectPhotoDataArrayCount() -> Int {
        return album[selectAlbumNumber!].photos[selectPhotoNumber!].photoName.count
    }
    
    func getSavePhotoId() -> String {
        return album[selectAlbumNumber!].photos[selectPhotoNumber!].photoID
    }
    
//  =============================Firebase================================
    
    func loadAllData(getType: DataEventType, completion:@escaping () -> ()) {
       checkUserData(getType: getType) { (userCheck) in
            if userCheck == true {
                self.getAlbumData(getType: getType, completion: {
                    self.getPhotoData(getType: getType, completion: {
                        self.UserRef.removeAllObservers()
                        self.albumRef.removeAllObservers()
                        self.photoRef.removeAllObservers()
                        self.dowloadAllPhoto()
                        completion()
                    })
                })
            } else {
                self.firstUserData(completion: { 
                    self.checkUserData(getType: getType, completion: { (_) in
                        self.getAlbumData(getType: getType, completion: {
                            self.getPhotoData(getType: getType, completion: {
                                self.UserRef.removeAllObservers()
                                self.albumRef.removeAllObservers()
                                self.photoRef.removeAllObservers()
                                self.dowloadAllPhoto()
                                completion()
                            })
                        })
                    })
                })
            }
        }
    }
    
    
    func saveAlbumDataToFirebase(name:String, startDate:TimeInterval, endDate:TimeInterval, image:UIImage, completion: @escaping () -> ()) {
        let imageFilePath = "\(Auth.auth().currentUser?.uid)/\(Date.timeIntervalSinceReferenceDate)"
        let data = UIImageJPEGRepresentation(image, 0.01)
        let meataData = StorageMetadata()
        Storage.storage().reference().child(imageFilePath).putData(data!, metadata: meataData) { (metadata, error) in
            if error != nil {
                return
            } else {
                let fileURL = meataData.downloadURLs![0].absoluteString
                let newAlbum = self.albumRef.childByAutoId().key
                let albumData = ["travelName": name, "startDate": startDate, "endDate":endDate, "image": fileURL] as [String : Any]
                self.albumRef.child(newAlbum).setValue(albumData)
                if self.userData?.participateAlbum == nil {
                self.UserRef.child((Auth.auth().currentUser?.uid)!).child("participateAlbum").setValue([newAlbum:newAlbum])
                    completion()
                } else {
                self.UserRef.child((Auth.auth().currentUser?.uid)!).child("participateAlbum").updateChildValues([newAlbum:newAlbum])
                    completion()
                }
            }
        }
    }
    
    func savePhotoDataToFirebase(photoID:String, photoData: savePhotoDataModel, completion: () -> ()) {
        let savePhotoData = ["photoID":photoData.photoID, "albumID":photoData.albumID, "locationName":photoData.locationName, "picturesDay":photoData.picturesDay, "latitude": photoData.latitude, "longitude":photoData.longitude] as [String : Any]
        self.photoRef.child(photoID).setValue(savePhotoData)
        completion()
    }
    
    
    func savePhotoToFirebase(PhotoArray: [modelPhotosData], saveId:String, completion: @escaping () -> ()) {
        print(PhotoArray.count)
        var testSwitch = false
        for i in 0..<PhotoArray.count {
           savePhotoImage(photo: PhotoArray[i].image, saveID: saveId, completion: { (meataData) in
                self.savePhotoDataToDatabase(meataData: meataData, setBool: testSwitch, photoID: saveId, completion: { 
                    testSwitch = true
                    print(i)
                    if i == PhotoArray.count - 1 {
                        completion()
                    }
                })
           })
        }
    }
    
    private func savePhotoImage(photo: UIImage, saveID:String, completion: @escaping (StorageMetadata) -> ()) {
        let imageFilePath = "\(saveID)/\(Date.timeIntervalSinceReferenceDate)"
        let data = UIImageJPEGRepresentation(photo, 0.01)
        let meataData = StorageMetadata()
        Storage.storage().reference().child(imageFilePath).putData(data!, metadata: meataData, completion: { (meataData, error) in
            if error != nil {
                return
            } else {
                completion(meataData!)
            }
        })
    }
    
    private func savePhotoDataToDatabase(meataData:StorageMetadata,setBool:Bool, photoID:String, completion: () -> ()) {
        print(setBool)
        let fileURL = meataData.downloadURL()?.absoluteString
        let photoId = self.photoRef.childByAutoId().key
        if self.album[self.selectAlbumNumber!].photos[self.selectPhotoNumber!].photoName.count == 0 {
            if setBool == false {
                self.photoRef.child(photoID).child("Photo").setValue([photoId: fileURL])
                completion()
            } else {
                self.photoRef.child(photoID).child("Photo").updateChildValues([photoId:fileURL!])
                completion()
            }
        } else {
            self.photoRef.child(photoID).child("Photo").updateChildValues([photoId:fileURL!])
            completion()
        }
    }
    
    
    private func firstUserData(completion:() -> ()) {
        let newUser = UserRef.child((Auth.auth().currentUser?.uid)!)
        let userId = ["userId": Auth.auth().currentUser?.uid]
        newUser.setValue(userId)
        completion()
    }
    
    private func checkUserData(getType: DataEventType, completion: @escaping (Bool) -> ()) {
        self.UserRef.observe(.value, with: { (snapshot) in
            if let userDict = snapshot.value as? [String: AnyObject] {
                for i in 0..<userDict.count {
                    if Array(userDict.keys)[i] == Auth.auth().currentUser?.uid {
                        if let getTheAlbumId = Array(userDict.values)[i] as? [String: AnyObject] {
                            let userId = getTheAlbumId["userId"] as? String
                            let albumID = getTheAlbumId["participateAlbum"] as? [String:String]
                            let setActivity = getTheAlbumId["setActivity"] as? [String:String]
                            let participateActivity = getTheAlbumId["participateActivity"] as? [String:String]
                            let userData = UserModel(userId: userId!, participateAlbum: albumID, setActivity: setActivity, participateActivity: participateActivity)
                            self.userData = userData
                            completion(true)
                        }
                    }
                }
            }
        })
    }
    
    private func getAlbumData(getType: DataEventType, completion:@escaping () -> ()) {
        album.removeAll()
        var loadAlbumModel = Album(albumID: String(), travelName: String(), startDate: Double(), endDate: Double(), titleImage: String(), photos: [PhotoDataModel]())
        if userData?.participateAlbum != nil {
            albumRef.observe(getType, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject] {
                    if let userAlbumKey = self.userData?.participateAlbum?.keys {
                        for x in userAlbumKey {
                            for i in 0..<dict.count {
                                if Array(dict.keys)[i] == x  {
                                    if let getDetail = Array(dict.values)[i] as? [String:AnyObject] {
                                        let albumKey = Array(dict.keys)[i]
                                        let name = getDetail["travelName"] as? String
                                        let startDate = getDetail["startDate"] as? Double
                                        let endDate = getDetail["endDate"] as? Double
                                        let titleImage = getDetail["image"] as? String
                                        Library.firstDownloadImage(url: titleImage!)
                                        loadAlbumModel = Album(albumID: albumKey, travelName: name!, startDate: startDate!, endDate: endDate!, titleImage: titleImage!, photos: [PhotoDataModel]())
                                        self.album.append(loadAlbumModel)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                completion()
            })
        }
    }
    
    private func getPhotoData(getType: DataEventType, completion: @escaping () -> ()) {
        photoRef.observe(getType, with: { (snapshot) in
            if let photodict = snapshot.value as? [String: AnyObject] {
                for x in 0..<photodict.count {
                    if let getPhotoDetail = Array(photodict.values)[x] as? [String: AnyObject] {
                        let albumID = getPhotoDetail["albumID"] as? String
                    for i in self.album {
                            if albumID == i.albumID {
                                print(i.titleImage)
                                let photoID = getPhotoDetail["photoID"] as? String
                                let locationName = getPhotoDetail["locationName"] as? String
                                let picturesDay = getPhotoDetail["picturesDay"] as? Double
                                let latitude = getPhotoDetail["latitude"] as? Double
                                let longitude = getPhotoDetail["longitude"] as? Double
                                if i.photos.count == 0 {
                                    let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: [String](), picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: true)
                                    i.photos.append(loadPhotoModel)
                                } else {
                                    let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: [String](), picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: false)
                                    i.photos.append(loadPhotoModel)
                                }
                            }
                        }
                    }
                }
            }
            completion()
        })
    }
    
    
    private func dowloadAllPhoto() {
        if album.count != 0 {
            for i in album {
                if i.photos.count != 0 {
                    for x in i.photos {
                        if x.photoName.count != 0 {
                            for z in x.photoName {
                                Library.firstDownloadImage(url: z)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension FirebaseServer {
    
}

