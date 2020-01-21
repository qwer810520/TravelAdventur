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

typealias JSONDictionary = [String: Any]

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    private(set) var loginUserModel: LoginUserModel?
    
    private let userManager = Firestore.firestore().collection("User")
    private let albumManager = Firestore.firestore().collection("Album")
    private let placeManager = Firestore.firestore().collection("Place")

    // MARK: - User API Method
    
    func signInForFirebase(credential: AuthCredential, complectionHandler: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(with: credential) { [weak self] (user, error) in
            guard error == nil, let userData = user else {
                complectionHandler(error)
                return
            }
            
            self?.loginUserModel = LoginUserModel(uid: userData.user.uid, name: userData.user.displayName ?? "", photoURL: userData.user.photoURL?.absoluteString ?? "")
            
            complectionHandler(nil)
        }
    }
    
    func getUserProfile(complectionHandler: @escaping (_ error: Error?) -> Void) {
        guard let user = loginUserModel else { return }
        userManager.document(user.uid).getDocument { [weak self] (response, error) in
            guard error == nil, let result = response?.exists, let data = response?.data() else {
                complectionHandler(error)
                return
            }
            switch result {
            case true:
                self?.loginUserModel = LoginUserModel(json: data)
                complectionHandler(nil)
            case false:
                self?.addUserDataForFirebase(user: user, complectionHandler: { (error) in
                    guard error == nil else {
                        complectionHandler(error)
                        return
                    }
                    complectionHandler(nil)
                })
            }
        }
    }
    
    func addUserDataForFirebase(user: LoginUserModel, complectionHandler: @escaping (_ error: Error?) -> Void) {
        let parameters = ["uid": user.uid, "userName": user.name, "userPhoto": user.photoURL] as JSONDictionary
        userManager.document(user.uid).setData(parameters) { (error) in
            guard error == nil else {
                complectionHandler(error)
                return
            }
            complectionHandler(nil)
        }
    }
    
    func addAlbumIdToUserData(id: String, complectionHandler: @escaping  (_ error: Error?) -> Void) {
        guard let user = loginUserModel else { return }
        userManager.document(user.uid)
            .updateData(["albumIdList": FieldValue.arrayUnion([id])]) { (error) in
                guard error == nil else {
                    complectionHandler(error)
                    return
                }
                complectionHandler(nil)
        }
    }
    
    // MARK: - Album API Method
    
    func addNewAlbumData(model: AddAlbumModel,  complectionHandler: @escaping (_ error: Error?) -> Void) {
        var addAlbumModel = model
        addAlbumModel.id = albumManager.document().documentID
        saveAlbumPhotoData(model: addAlbumModel) { [weak self] (fileURL, error) in
            guard error == nil else {
                complectionHandler(error)
                return
            }
             let parameters = ["id": addAlbumModel.id, "title": addAlbumModel.title, "startTime": addAlbumModel.startTime, "day": addAlbumModel.day, "coverPhotoURL": fileURL] as JSONDictionary
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
    
    func getAlbumData(complectionHandler: @escaping (_ album: [AlbumModel], _ error: Error?) -> Void) {
        albumManager.getDocuments { [weak self] (albumList, error) in
            guard error == nil, let responseData = albumList  else {
                complectionHandler([AlbumModel](), error)
                return
            }
            
            var albumList = [AlbumModel]()
            
            guard let userAlbumList = self?.loginUserModel?.albumIdList, !userAlbumList.isEmpty else {
                complectionHandler(albumList, nil)
                return
            }
            
            responseData.documents.forEach {
                let albumData = AlbumModel(json: $0.data())
                guard userAlbumList.contains(albumData.id) else { return }
                albumList.append(albumData)
            }
            complectionHandler(albumList, nil)
        }
    }
    
    func checkAlbumStatus(id: String, complectionHandler: @escaping (_ status: Bool, _ error: Error?) -> Void) {
        guard let user = loginUserModel else { return }
        albumManager.document(id).getDocument { [weak self] (response, error) in
            guard error == nil, let responseData = response else {
                complectionHandler(false, error)
                return
            }
            
            switch responseData.exists {
            case true:
                guard !user.albumIdList.contains(id) else {
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
    
    func addNewPlaceData(albumid: String, placeData: AddPlaceModel, complectionHandler: @escaping (_ error: Error?) -> Void) {
        let id = placeManager.document().documentID
        let parameters = ["albumID": albumid, "placeID": id, "name": placeData.placeName, "latitude": placeData.latitude, "longitude": placeData.longitude, "time": placeData.time] as JSONDictionary
        placeManager.document(id).setData(parameters) { (error) in
            guard error == nil else {
                complectionHandler(error)
                return
            }
            complectionHandler(nil)
        }
    }
    
    func getPlaceList(albumID: String, complectionHandler: @escaping (_ placeList: [PlaceModel], _ error: Error?) -> Void) {
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
    
    func getPlaceData(id: String, complectionHandler: @escaping (_ placeData: PlaceModel, _ error: Error?) -> Void) {
        placeManager.document(id).getDocument { (response, error) in
            guard error == nil, let responseData = response?.data() else {
                complectionHandler(PlaceModel(), error)
                return
            }
            let placeData = PlaceModel(json: responseData)
            complectionHandler(placeData, nil)
        }
    }
    
    func updatePhotoToPlaceData(placeID: String, photoURL: String,  complectionHandler: @escaping (_ error: Error?) -> Void) {
        placeManager.document(placeID).updateData(["photoList": FieldValue.arrayUnion([photoURL])]) { (error) in
            complectionHandler(error)
        }
    }
    
    func checkAlbumStatus() {
        
    }
    
    // MARK: - Storage API Method
    
    private func saveAlbumPhotoData(model: AddAlbumModel, complectionHandler: @escaping (_ fileURL: String, _ error: Error?) -> Void) {
        guard let image = model.coverPhoto else {
            complectionHandler("", nil)
            return
        }
        let filePath = "Album/\(model.id)/\(Date.timeIntervalSinceReferenceDate).jpg"
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        Storage.storage().reference().child(filePath)
            .putData(imageData, metadata: nil) { (_, error) in
                guard error == nil else {
                    complectionHandler("", error)
                    return
                }
                Storage.storage().reference().child(filePath)
                    .downloadURL(completion: { (url, error) in
                        guard error == nil, let url = url?.absoluteString else {
                            complectionHandler("", error)
                            return
                        }
                        complectionHandler(url, nil)
                })
        }
    }
    
    func savePhotoListData(placeID: String, photoList: [MobilePhotoModel], complectionHandler: @escaping (_ error: Error?) -> Void) {
        for i in 0..<photoList.count {
            let filePath = "Photos/\(placeID)/\(Date.timeIntervalSinceReferenceDate).jpg"
            guard let data = photoList[i].image?.jpegData(compressionQuality: 1) else { continue }
        Storage.storage().reference()
            .child(filePath)
            .putData(data, metadata: nil) { [weak self] (_, error) in
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
                    self?.updatePhotoToPlaceData(placeID: placeID, photoURL: url?.absoluteString ?? "", complectionHandler: { (error) in
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
