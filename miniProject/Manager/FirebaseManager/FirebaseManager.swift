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
import FirebaseAuth
import GoogleMaps
import LocalAuthentication
import FirebaseFirestore

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    private(set) var loginUserModel: LoginUserModel?
    
    private let userManager = Firestore.firestore().collection("User")
    private let albumManager = Firestore.firestore().collection("Album")
    private let photoManager = Firestore.firestore().collection("Photo")
    
    // MARK: - userManager Method
    
    func signInForFirebase(credential: AuthCredential, complectionHandler: @escaping (_ error: Error?) -> ()) {
        Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (user, error) in
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
            .updateData(["participateAlbum": FieldValue.arrayUnion([id])]) { (error) in
                guard error == nil else {
                    complectionHandler(error)
                    return
                }
                complectionHandler(nil)
        }
    }
    
    // MARK: - Album Method
    
    func addNewAlbumData(model: AddAlbumModel,  complectionHandler: @escaping (_ error: Error?) -> ()) {
        var addAlbumModel = model
        addAlbumModel.id = albumManager.document().documentID
        saveAlbumPhotoData(model: addAlbumModel) { [weak self] (fileURL, error) in
            guard error == nil else {
                complectionHandler(error)
                return
            }
             let parameters = ["id": addAlbumModel.id, "title": addAlbumModel.title, "startTiem": addAlbumModel.startTime, "day": addAlbumModel.day, "coverPhotoURL": fileURL] as TAStyle.JSONDictionary
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
                    })
            })
        }
    }
    
    // MARK: - Storage Method
    
    func saveAlbumPhotoData(model: AddAlbumModel, complectionHandler: @escaping (_ fileURL: String, _ error: Error?) -> ()) {
        let filePath = "Album/\(model.id)/\(Date.timeIntervalSinceReferenceDate).jpg"
        let data = UIImageJPEGRepresentation(model.titlePhoto!, 0.05)
        
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
    // MARK: -----------------------------------------------------------------------
    
    private override init() {
        album = []
        firstLogin = true
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(upDateAlnumData(Not:)), name: Notification.Name("updata"), object: nil)
    }
    
    @objc private func upDateAlnumData(Not:Notification) {
        if let string = Not.userInfo?["switch"] as? String {
            switch string {
            case "Album":
                 NotificationCenter.default.post(name: Notification.Name("albumSVP"), object: nil, userInfo: ["switch": true])
                updateAlbumData {
                    NotificationCenter.default.post(name: Notification.Name("albumSVP"), object: nil, userInfo: ["switch": false])
                    self.albumRef.removeAllObservers()
                }
            case "Place":
                NotificationCenter.default.post(name: Notification.Name("placeSVP"), object: nil, userInfo: ["switch": true])
                updatePlaceData {
                    self.photoRef.removeAllObservers()
                NotificationCenter.default.post(name: Notification.Name("placeSVP"), object: nil, userInfo: ["switch": false])
                }
            case "Photo":
                NotificationCenter.default.post(name: Notification.Name("photoSVP"), object: nil, userInfo: ["switch": true])
                updatePhotoData(getType: .value, completion: {
                    self.dowloadAllPhoto()
                    self.photoRef.removeAllObservers()
                    NotificationCenter.default.post(name: Notification.Name("photoSVP"), object: nil, userInfo: ["switch": false])
                })
            case "joinNewAlbum":
                NotificationCenter.default.post(name: Notification.Name("albumSVP"), object: nil, userInfo: ["switch": true])
                joinNewAlbumData {
                    self.albumRef.removeAllObservers()
                    self.joinNewPlaceData {
                        self.photoRef.removeAllObservers()
                        self.dowloadAllPhoto()
                        NotificationCenter.default.post(name: Notification.Name("albumSVP"), object: nil, userInfo: ["switch": false])
                    }
                }
            default:
                break
            }
        }
    }
    
    
    fileprivate var userData:UserModel?
    private var album:[Album]
    private var firstLogin:Bool
    private var userName:String?
    private var userPhotoURL:String?
    private var selectAlbumNumber:Int?
    private var selectPhotoNumber:Int?
    private var selectPhotoDetail:Int?
    private var addAlnumID:String?
    private var addPlaceID:String?
    private var Screenbrightness:Double?
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
//  =============================userData================================
    func getUserData() -> UserModel {
        return userData!
    }
    
   
//  =============================AlbumData================================
    func saveScreenbrightness(db:Double) {
        Screenbrightness = db
    }
    
    func getScreenbrightness() -> Double {
        return Screenbrightness!
    }
    
    func firstLoginSwitch() -> Bool {
        return firstLogin
    }
    
    func changeLoginSwitch() {
        firstLogin = false
    }
    
    func getSelectAlbumData() -> Album {
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
    
    func savePhotoDetailNumber(num:Int) {
        selectPhotoDetail = num
    }
    
    func getselectPhotoDetail() -> Int {
        return selectPhotoDetail!
    }
    
//  =============================Firebase================================
    
//  -----------------建立相簿-----------------
    func saveAlbumDataToFirebase(name:String, startDate:TimeInterval, endDate:TimeInterval, image:UIImage, completion: @escaping () -> ()) {
        print(image)
        let newAlbum = self.albumRef.childByAutoId().key
        saveAlbumPhoto(photo: image, albumID: newAlbum) { (metadata) in
//            let fileURL = metadata.downloadURL()?.absoluteString
            let albumData = ["travelName": name, "startDate": startDate, "endDate":endDate, "image": ""] as [String : Any]
            self.addAlnumID = newAlbum
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
    
    private func saveAlbumPhoto(photo:UIImage, albumID:String, completion:@escaping (StorageMetadata) -> ()) {
        let imageFilePath = "\(albumID)/\(Date.timeIntervalSinceReferenceDate)"
        let data = UIImageJPEGRepresentation(photo, 0.05)
        let meataData = StorageMetadata()
        Storage.storage().reference().child(imageFilePath).putData(data!, metadata: meataData) { (metaData, error) in
            if error != nil {
                return
            } else {
                completion(metaData!)
            }
        }
    }
//  -----------------儲存地點-----------------
    func savePhotoDataToFirebase(photoID:String, photoData: savePhotoDataModel, completion: () -> ()) {
        addPlaceID = photoID
        let savePhotoData = ["photoID":photoData.photoID, "albumID":photoData.albumID, "locationName":photoData.locationName, "picturesDay":photoData.picturesDay, "latitude": photoData.latitude, "longitude":photoData.longitude] as [String : Any]
        self.photoRef.child(photoID).setValue(savePhotoData)
        completion()
    }
    
//  -----------------最後儲存相片--------------------
    func savePhotoToFirebase(PhotoArray: [modelPhotosData], saveId:String, completion: @escaping () -> ()) {
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
        let imageFilePath = "\(album[selectAlbumNumber!].albumID)/\(saveID)/\(Date.timeIntervalSinceReferenceDate)"
        let data = UIImageJPEGRepresentation(photo, 1)
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
//        let fileURL = meataData.downloadURL()?.absoluteString
        let fileURL = ""
        let photoId = self.photoRef.childByAutoId().key
        if self.album[self.selectAlbumNumber!].photos[self.selectPhotoNumber!].photoName.count == 0 {
            if setBool == false {
                self.photoRef.child(photoID).child("Photo").setValue([photoId: fileURL])
                completion()
            } else {
                self.photoRef.child(photoID).child("Photo").updateChildValues([photoId:fileURL])
                completion()
            }
        } else {
            self.photoRef.child(photoID).child("Photo").updateChildValues([photoId:fileURL])
            completion()
        }
    }
    
// -------------------loadFireBaseData------------------------
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
                        return
                    })
                })
            }
        }
    }
//  -----------------使用者資訊確認----------------------
    func setUserData(name:String, userPhoto:String, completion:() -> ()) {
        userName = name
        userPhotoURL = userPhoto
        completion()
    }
    
    private func firstUserData(completion:() -> ()) {
        let newUser = UserRef.child((Auth.auth().currentUser?.uid)!)
        let userId = ["userId": Auth.auth().currentUser?.uid, "userName": userName, "userPhoto": userPhotoURL]
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
                            let userName = getTheAlbumId["userName"] as? String
                            let userPhoto = getTheAlbumId["userPhoto"] as? String
                            let albumID = getTheAlbumId["participateAlbum"] as? [String:String]
                            let setActivity = getTheAlbumId["setActivity"] as? [String:String]
                            let participateActivity = getTheAlbumId["participateActivity"] as? [String:String]
                            Library.firstDownloadImage(url: userPhoto!)
                            let userData = UserModel(userId: userId!, userName: userName!, userPhoto: userPhoto!, participateAlbum: albumID, setActivity: setActivity, participateActivity: participateActivity)
                            self.userData = userData
                            completion(true)
                        }
                    }
                }
            } else {
                completion(false)
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
        } else {
            completion()
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
                                let photoID = getPhotoDetail["photoID"] as? String
                                let locationName = getPhotoDetail["locationName"] as? String
                                let picturesDay = getPhotoDetail["picturesDay"] as? Double
                                let latitude = getPhotoDetail["latitude"] as? Double
                                let longitude = getPhotoDetail["longitude"] as? Double
                                var photoArray = [String]()
                                if let photo = getPhotoDetail["Photo"] as? [String:String] {
                                    for photo in photo {
                                        photoArray.append(photo.value)
                                    }
                                }
                                if i.photos.count == 0 {
                                    let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: photoArray, picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: true)
//                                    i.photos.append(loadPhotoModel)
                                } else {
                                    let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: photoArray, picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: false)
//                                    i.photos.append(loadPhotoModel)
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
// ========================Firebase更新資料==============================
    private func updateAlbumData(completion:@escaping () -> ()) {
        var loadAlbumModel = Album(albumID: String(), travelName: String(), startDate: Double(), endDate: Double(), titleImage: String(), photos: [PhotoDataModel]())
        albumRef.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject] {
                for i in 0..<dict.count {
                    if Array(dict.keys)[i] == self.addAlnumID  {
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
            completion()
        })
    }
    
    private func updatePlaceData(completion:@escaping () -> ()) { 
        photoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let photodict = snapshot.value as? [String: AnyObject] {
                for x in 0..<photodict.count {
                    if let getPhotoDetail = Array(photodict.values)[x] as? [String:AnyObject] {
                        let photoID = getPhotoDetail["photoID"] as? String
                        if photoID == self.addPlaceID {
                            let albumID = getPhotoDetail["albumID"] as? String
                            let locationName = getPhotoDetail["locationName"] as? String
                            let picturesDay = getPhotoDetail["picturesDay"] as? Double
                            let latitude = getPhotoDetail["latitude"] as? Double
                            let longitude = getPhotoDetail["longitude"] as? Double
                            var photoArray = [String]()
                            if let photo = getPhotoDetail["Photo"] as? [String:String] {
                                for photo in photo {
                                    photoArray.append(photo.value)
                                }
                            }
                            if self.album[self.selectAlbumNumber!].photos.count == 0 {
                                let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: photoArray, picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: true)
                                self.album[self.selectAlbumNumber!].photos.append(loadPhotoModel)
                            } else {
                                let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: photoArray, picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: false)
                                self.album[self.selectAlbumNumber!].photos.append(loadPhotoModel)
                            }

                        }
                    }
                }
            }
            completion()
        })
    }
    
    
    private func updatePhotoData(getType: DataEventType, completion: @escaping () -> ()) {
        photoRef.observe(getType, with: { (snapshot) in
            if let photodict = snapshot.value as? [String: AnyObject] {
                for x in 0..<photodict.count {
                    if let getPhotoDetail = Array(photodict.values)[x] as? [String: AnyObject] {
                        let albumID = getPhotoDetail["albumID"] as? String
                        for i in self.album {
                            if albumID == i.albumID {
                                let photoID = getPhotoDetail["photoID"] as? String
                                for z in i.photos {
                                    if photoID == z.photoID {
                                        if let photoData = getPhotoDetail["Photo"] as? [String:String] {
                                            z.photoName.removeAll()
                                            for photo in photoData {
                                                z.photoName.append(photo.value)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                completion()
            }
        })
    }
    
//  ========================QRcode加入新相簿==============================
    
    func checkJoinNewAlbumID(str:String, completion:@escaping (Bool) -> ()) {
        addAlnumID = str
        checkJoinNewAlbumID { (check) in
            if check == true {
                if self.userData?.participateAlbum == nil {
                self.UserRef.child((Auth.auth().currentUser?.uid)!).child("participateAlbum").setValue([str:str])
                    completion(check)
                } else {
                self.UserRef.child((Auth.auth().currentUser?.uid)!).child("participateAlbum").updateChildValues([str:str])
                    completion(check)
                }
            } else {
            completion(check)
            }
 
        }
    }
    
    
    private func checkJoinNewAlbumID(completion:@escaping (Bool) -> ()) {
        albumRef.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject] {
                for i in 0..<dict.count {
                    if Array(dict.keys)[i] == self.addAlnumID  {
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        })
    }

    private func joinNewAlbumData(completion:@escaping () -> ()) {
        var loadAlbumModel = Album(albumID: String(), travelName: String(), startDate: Double(), endDate: Double(), titleImage: String(), photos: [PhotoDataModel]())
        albumRef.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject] {
                for i in 0..<dict.count {
                    if Array(dict.keys)[i] == self.addAlnumID  {
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
            completion()
        })
    }
    
    private func joinNewPlaceData(completion:@escaping () -> ()) {
        photoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let photodict = snapshot.value as? [String: AnyObject] {
                for x in 0..<photodict.count {
                    if let getPhotoDetail = Array(photodict.values)[x] as? [String:AnyObject] {
                        let albumID = getPhotoDetail["albumID"] as? String
                        if albumID == self.addAlnumID {
                            let photoID = getPhotoDetail["photoID"] as? String
                            let locationName = getPhotoDetail["locationName"] as? String
                            let picturesDay = getPhotoDetail["picturesDay"] as? Double
                            let latitude = getPhotoDetail["latitude"] as? Double
                            let longitude = getPhotoDetail["longitude"] as? Double
                            var photoArray = [String]()
                            if let photo = getPhotoDetail["Photo"] as? [String:String] {
                                for photo in photo {
                                    photoArray.append(photo.value)
                                }
                            }
                            for i in self.album {
                                if i.albumID == albumID {
                                    if i.photos.count == 0 {
                                         let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: photoArray, picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: true)
//                                        i.photos.append(loadPhotoModel)
                                    } else {
                                        let loadPhotoModel = PhotoDataModel(albumID: albumID!, photoID: photoID!, locationName: locationName!, photoName: photoArray, picturesDay: picturesDay!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), selectSwitch: false)
//                                        i.photos.append(loadPhotoModel)
                                    }
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

extension FirebaseManager {
    
    
}
