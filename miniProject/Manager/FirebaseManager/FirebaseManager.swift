//
//  FirebaseServer.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/5/29.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import GoogleMaps
import LocalAuthentication
import FirebaseFirestore

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    private(set) var loginUserModel: LoginUserModel?
    
    private let userManager = Firestore.firestore().collection("User")
    private let albumManager = Firestore.firestore().collection("Album")
    private let placeManager = Firestore.firestore().collection("Place")
    
    
    // MARK: - User API Method
    
    func signInForFirebase(credential: AuthCredential, complectionHandler: @escaping (_ error: Error?) -> ()) {
        Auth.auth().signIn(with: credential) { [weak self] (user, error) in
            guard error == nil, let userData = user else {
                complectionHandler(error!)
                return
            }
            
            self?.loginUserModel = LoginUserModel(uid: userData.user.uid, name: userData.user.displayName!, photoURL: userData.user.photoURL?.absoluteString ?? "")
            
            complectionHandler(nil)
        }
    }
    
    func getUserProfile(complectionHandler: @escaping (_ error: Error?) -> ()) {
        userManager.document((loginUserModel?.uid)!).getDocument { [weak self] (userData, error) in
            guard error == nil, let responseData = userData else {
                complectionHandler(error)
                return
            }
            switch responseData.exists {
            case true:
                self?.loginUserModel = LoginUserModel(json: (responseData.data())!)
                complectionHandler(nil)
            case false:
                self?.addUserDataForFirebase(user: (self?.loginUserModel)!, complectionHandler: { (error) in
                    guard error == nil else {
                        complectionHandler(error)
                        return
                    }
                    complectionHandler(nil)
                })
            }
        }
    }
    
    func addUserDataForFirebase(user: LoginUserModel, complectionHandler: @escaping (_ error: Error?) -> ()) {
        let parameters = ["uid": user.uid, "userName": user.name, "userPhoto": user.photoURL] as TAStyle.JSONDictionary
        userManager.document(user.uid).setData(parameters) { (error) in
            guard error == nil else {
                complectionHandler(error)
                return
            }
            complectionHandler(nil)
        }
    }
    
    func addAlbumIdToUserData(id: String, complectionHandler: @escaping  (_ error: Error?) -> ()) {
        userManager.document((loginUserModel?.uid)!)
            .updateData(["albumIdList": FieldValue.arrayUnion([id])]) { (error) in
                guard error == nil else {
                    complectionHandler(error)
                    return
                }
                complectionHandler(nil)
        }
    }
    
    // MARK: - Album API Method
    
    func addNewAlbumData(model: AddAlbumModel,  complectionHandler: @escaping (_ error: Error?) -> ()) {
        var addAlbumModel = model
        addAlbumModel.id = albumManager.document().documentID
        saveAlbumPhotoData(model: addAlbumModel) { [weak self] (fileURL, error) in
            guard error == nil else {
                complectionHandler(error)
                return
            }
             let parameters = ["id": addAlbumModel.id, "title": addAlbumModel.title, "startTime": addAlbumModel.startTime, "day": addAlbumModel.day, "coverPhotoURL": fileURL] as TAStyle.JSONDictionary
            self?.albumManager.document(addAlbumModel.id)
                .setData(parameters, completion: { (error) in
                    guard error == nil else {
                        complectionHandler(error)
                        return
                    }
                    self?.addAlbumIdToUserData(id: addAlbumModel.id, complectionHandler: { (error) in
                        guard error == nil else {
                            complectionHandler(error)
                            return
                        }
                        complectionHandler(nil)
                        self?.loginUserModel?.albumIdList
                            .append(addAlbumModel.id)
                    })
            })
        }
    }
    
    func getAlbumData(complectionHandler: @escaping (_ album: [AlbumModel], _ error: Error?) -> ()) {
        albumManager.getDocuments { (albumList, error) in
            guard error == nil, let responseData = albumList  else {
                complectionHandler([AlbumModel](), error)
                return
            }
            
            var albumList = [AlbumModel]()
            
            guard !(self.loginUserModel?.albumIdList.isEmpty)! else {
                complectionHandler(albumList, nil)
                return
            }
            
            responseData.documents.forEach {
                let albumData = AlbumModel(json: $0.data())
                guard (self.loginUserModel?.albumIdList.contains(where: { $0 == albumData.id}))! else {
                    return
                }
                albumList.append(albumData)
            }
            complectionHandler(albumList, nil)
        }
    }
    
    func checkAlbumStatus(id: String, complectionHandler: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        albumManager.document(id).getDocument { [weak self] (response, error) in
            guard error == nil, let responseData = response else {
                complectionHandler(false, error)
                return
            }
            
            switch responseData.exists {
            case true:
                guard !(self?.loginUserModel?.albumIdList.contains(where: { $0 == id }))! else {
                        complectionHandler(false, error)
                        return
                    }
                self?.addAlbumIdToUserData(id: id, complectionHandler: { (error) in
                    guard error == nil else {
                        complectionHandler(false, nil)
                        return
                    }
                    complectionHandler(true, error)
                })
            case false:
                complectionHandler(responseData.exists, nil)
            }
        }
    }
    
    // MARK: - Place API Method
    
    func addNewPlaceData(albumid: String, placeData: AddPlaceModel, complectionHandler: @escaping (_ error: Error?) -> ()) {
        let id = placeManager.document().documentID
        let parameters = ["albumID": albumid, "placeID": id, "name": placeData.placeName, "latitude": placeData.latitude, "longitude": placeData.longitude, "time": placeData.time] as TAStyle.JSONDictionary
        placeManager.document(id).setData(parameters) { (error) in
            guard error == nil else {
                complectionHandler(error)
                return
            }
            complectionHandler(nil)
        }
    }
    
    func getPlaceList(albumID: String, complectionHandler: @escaping (_ placeList: [PlaceModel], _ error: Error?) -> ()) {
        placeManager.getDocuments { (response, error) in
            guard error == nil, let responseData = response else {
                complectionHandler([PlaceModel](), error)
                return
            }
            
            var placeList = [PlaceModel]()
            responseData.documents.forEach { placeList.append(PlaceModel(json: $0.data())) }
            complectionHandler( placeList.filter { $0.albumID == albumID }.sorted(by: { $0.time < $1.time }), nil)
        }
    }
    
    func getPlaceData(id: String, complectionHandler: @escaping (_ placeData: PlaceModel, _ error: Error?) -> ()) {
        placeManager.document(id).getDocument { (response, error) in
            guard error == nil, let responseData = response?.data() else {
                complectionHandler(PlaceModel(), error)
                return
            }
            let placeData = PlaceModel(json: responseData)
            complectionHandler(placeData, nil)
        }
    }
    
    func updatePhotoToPlaceData(placeID: String, photoURL: String,  complectionHandler: @escaping (_ error: Error?) -> ()) {
        placeManager.document(placeID).updateData(["photoList": FieldValue.arrayUnion([photoURL])]) { (error) in
            complectionHandler(error)
        }
    }
    
    func checkAlbumStatus() {
        
    }
    
    // MARK: - Storage API Method
    
    private func saveAlbumPhotoData(model: AddAlbumModel, complectionHandler: @escaping (_ fileURL: String, _ error: Error?) -> ()) {
        let filePath = "Album/\(model.id)/\(Date.timeIntervalSinceReferenceDate).jpg"
        let data = UIImageJPEGRepresentation(model.coverPhoto!, 1)
        
        Storage.storage().reference().child(filePath)
            .putData(data!, metadata: nil) { (metaData, error) in
                guard error == nil else {
                    complectionHandler("", error)
                    return
                }
                Storage.storage().reference().child(filePath)
                    .downloadURL(completion: { (url, error) in
                        guard error == nil else {
                            complectionHandler("", error)
                            return
                        }
                        complectionHandler((url?.absoluteString)!, nil)
                })
        }
    }
    
    func savePhotoListData(placeID: String, photoList: [MobilePhotoModel], complectionHandler: @escaping (_ error: Error?) -> ()) {
        for i in 0..<photoList.count {
            let filePath = "Photos/\(placeID)/\(Date.timeIntervalSinceReferenceDate).jpg"
            let data = UIImageJPEGRepresentation(photoList[i].image, 1)
        Storage.storage().reference()
            .child(filePath)
            .putData(data!, metadata: nil) { [weak self] (metaData, error) in
                guard error == nil else {
                    complectionHandler(error)
                    return
                }
            Storage.storage().reference()
                .child(filePath)
                .downloadURL(completion: { (url, error) in
                    guard error == nil else {
                        complectionHandler(error)
                        return
                    }
                    self?.updatePhotoToPlaceData(placeID: placeID, photoURL: (url?.absoluteString)!, complectionHandler: { (error) in
                        guard error == nil else {
                            complectionHandler(error)
                            return
                        }
                        
                        if i == photoList.count - 1 {
                            complectionHandler(nil)
                        }
                    })
                })
            }
        }
    }
}
