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

class FirebaseManager2: NSObject {

  static let shared = FirebaseManager2()

  private(set) var loginUserModel: LoginUserModel?

  private let userManager = Firestore.firestore().collection("User")
  private let albumManager = Firestore.firestore().collection("Album")
  private let placeManager = Firestore.firestore().collection("Place")

  // MARK: - User API Method

  func signInForFirebase(credential: AuthCredential, complectionHandler: @escaping (Result<Bool, Error>) -> Void) {
    Auth.auth().signIn(with: credential) { [weak self] (user, error) in
      guard error == nil, let userData = user else {
        if let error = error {
          complectionHandler(.failure(error))
        }
        return
      }

      self?.loginUserModel = LoginUserModel(uid: userData.user.uid, name: userData.user.displayName ?? "", photoURL: userData.user.photoURL?.absoluteString ?? "")
      complectionHandler(.success(true))
    }
  }

  func getUserProfile(complectionHandler: @escaping (Result<Bool, Error>) -> Void) {
    guard let user = loginUserModel else { return }
    userManager.document(user.uid).getDocument { [weak self] (response, error) in
      guard error == nil, let result = response?.exists, let data = response?.data() else {
        if let error = error {
          complectionHandler(.failure(error))
        }
        return
      }
      switch result {
        case true:
          self?.loginUserModel = LoginUserModel(json: data)
          complectionHandler(.success(true))
        case false:
          self?.addUserDataForFirebase(user: user, complectionHandler: { result in
            switch result {
              case .success:
                complectionHandler(.success(true))
              case .failure(let error):
                complectionHandler(.failure(error))
            }
          })
      }
    }
  }

  private func addUserDataForFirebase(user: LoginUserModel, complectionHandler: @escaping (Result<Bool, Error>) -> Void) {
    let parameters = ["uid": user.uid, "userName": user.name, "userPhoto": user.photoURL] as JSONDictionary
    userManager.document(user.uid).setData(parameters) { (error) in
      switch error {
        case .some(let error):
          complectionHandler(.failure(error))
        case .none:
          complectionHandler(.success(true))
      }
    }
  }

  private func addAlbumIdToUserData(id: String, complectionHandler: @escaping  (Result<Bool, Error>) -> Void) {
    guard let user = loginUserModel else { return }
    userManager.document(user.uid)
      .updateData(["albumIdList": FieldValue.arrayUnion([id])]) { error in
        switch error {
          case .some(let error):
            complectionHandler(.failure(error))
          case .none:
            complectionHandler(.success(true))
        }
    }
  }

  // MARK: - Album API Method

  func addNewAlbumData(model: AddAlbumModel,  complectionHandler: @escaping (Result<Bool, Error>) -> Void) {
    var addAlbumModel = model
    addAlbumModel.id = albumManager.document().documentID
    saveAlbumPhotoData(model: addAlbumModel) { [weak self] (fileURL, error) in
      switch error {
        case .some(let error):
          complectionHandler(.failure(error))
        case .none:
          let parameters = ["id": addAlbumModel.id, "title": addAlbumModel.title, "startTime": addAlbumModel.startTime, "day": addAlbumModel.day, "coverPhotoURL": fileURL] as JSONDictionary
          self?.albumManager.document(addAlbumModel.id).setData(parameters, completion: { error in
            switch error {
              case .some(let error):
                complectionHandler(.failure(error))
              case .none:
                self?.addAlbumIdToUserData(id: addAlbumModel.id, complectionHandler: { res in
                  switch res {
                    case .success:
                      self?.loginUserModel?.albumIdList.append(addAlbumModel.id)
                      complectionHandler(.success(true))
                    case .failure(let error):
                      complectionHandler(.failure(error))
                  }
                })
            }
          })
      }
    }
  }

  func getAlbumData(complectionHandler: @escaping (Result<[AlbumModel], Error>) -> Void) {
    albumManager.getDocuments { [weak self] albumList, error in
      guard error == nil, let responseData = albumList, let userAlbumList = self?.loginUserModel?.albumIdList, !userAlbumList.isEmpty else {
        if let error = error {
          complectionHandler(.failure(error))
        }
        return
      }

      var albumList = [AlbumModel]()

      responseData.documents.forEach {
        let albumData = AlbumModel(json: $0.data())
        guard userAlbumList.contains(albumData.id) else { return }
        albumList.append(albumData)
      }
      complectionHandler(.success(albumList))
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
          self?.addAlbumIdToUserData(id: id, complectionHandler: { res in
            switch res {
              case .failure(let error):
                complectionHandler(false, error)
              case .success:
                complectionHandler(false, nil)
            }
          })
        case false:
          complectionHandler(responseData.exists, nil)
      }
    }
  }

  // MARK: - Place API Method

  func addNewPlaceData(albumid: String, placeData: AddPlaceModel, complectionHandler: @escaping (Result<Bool, Error>) -> Void) {
    let id = placeManager.document().documentID
    let parameters = ["albumID": albumid, "placeID": id, "name": placeData.placeName, "latitude": placeData.latitude, "longitude": placeData.longitude, "time": placeData.time] as JSONDictionary
    placeManager.document(id).setData(parameters) { (error) in
      guard error == nil else {
        if let error = error {
          complectionHandler(.failure(error))
        }
        return
      }
      complectionHandler(.success(true))
    }
  }

  func getPlaceList(albumID: String, complectionHandler: @escaping (Result<[PlaceModel], Error>) -> Void) {
    placeManager.getDocuments { (response, error) in
      guard error == nil, let responseData = response else {
        if let error = error {
          complectionHandler(.failure(error))
        }
        return
      }

      let placeList = responseData.documents
        .map { PlaceModel(json: $0.data()) }
        .filter { $0.albumID == albumID }
        .sorted { $0.time < $1.time }
      
      complectionHandler(.success(placeList))
    }
  }

  func getPlaceData(id: String, complectionHandler: @escaping (Result<[String], Error>) -> Void) {
    placeManager.document(id).getDocument { response, error in
      guard error == nil, let responseData = response?.data() else {
        if let error = error {
          complectionHandler(.failure(error))
        }
        return
      }
      let placeData = PlaceModel(json: responseData)
      complectionHandler(.success(placeData.photoList))
    }
  }

  func updatePhotoToPlaceData(placeID: String, photoURL: String,  complectionHandler: @escaping (_ error: Error?) -> Void) {
    placeManager.document(placeID).updateData(["photoList": FieldValue.arrayUnion([photoURL])]) { (error) in
      complectionHandler(error)
    }
  }

  // MARK: - Storage API Method

  private func saveAlbumPhotoData(model: AddAlbumModel, complectionHandler: @escaping (_ fileURL: String, _ error: Error?) -> Void) {
    guard let image = model.coverPhoto else {
      complectionHandler("", nil)
      return
    }
    let filePath = "Album/\(model.id)/\(Date.timeIntervalSinceReferenceDate).jpg"
    guard let imageData = image.scaleZoomPhoto().jpegData(compressionQuality: 1) else { return }

    Storage.storage()
      .reference()
      .child(filePath)
      .putData(imageData, metadata: nil) { (_, error) in
        guard error == nil else {
          complectionHandler("", error)
          return
        }
        Storage.storage()
          .reference()
          .child(filePath)
          .downloadURL(completion: { (url, error) in
            guard error == nil, let url = url?.absoluteString else {
              complectionHandler("", error)
              return
            }
            complectionHandler(url, nil)
          })
    }
  }

  func savePhotoListData(placeID: String, photoList: [MobilePhotoModel], complectionHandler: @escaping (Result<Bool, Error>) -> Void) {
    for i in 0..<photoList.count {
      let filePath = "Photos/\(placeID)/\(Date.timeIntervalSinceReferenceDate).jpg"
      guard let data = photoList[i].image?.scaleZoomPhoto().jpegData(compressionQuality: 1) else { continue }
      Storage.storage().reference()
        .child(filePath)
        .putData(data, metadata: nil) { [weak self] (_, error) in
          guard error == nil else {
            if let error = error {
              complectionHandler(.failure(error))
            }
            return
          }
          Storage.storage().reference()
            .child(filePath)
            .downloadURL(completion: { (url, error) in
              guard error == nil, let url = url else {
                if let error = error {
                  complectionHandler(.failure(error))
                }
                return
              }
              self?.updatePhotoToPlaceData(placeID: placeID, photoURL: url.absoluteString, complectionHandler: { (error) in
                guard error == nil else {
                  if let error = error {
                    complectionHandler(.failure(error))
                  }
                  return
                }
                
                if i == photoList.count - 1 {
                  complectionHandler(.success(true))
                }
              })
            })
      }
    }
  }
}
