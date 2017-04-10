//
//  PhotoDataModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/27.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//
import UIKit
import Foundation
import MapKit

class PhotoDataModel {
    //    var name:String
    var photoName: Array<String>
    var picturesDay: String
    var coordinate:CLLocationCoordinate2D
    
    init(photoName: Array<String>, picturesDay:String, coordinate:CLLocationCoordinate2D) {
        self.photoName = photoName
        self.picturesDay = picturesDay
        self.coordinate = coordinate
    }
}



struct AlbumSeed {
    var album:[Album] = [
        //        Album(travelName: "苗栗三日", time: "2017-07-14", day: "3", titleImage: "test5", photos: [PhotoDataModel.init(name: "test1", day: "1", longitude: 24.599914, latitude: 120.998852), PhotoDataModel.init(name: "test2", day: "1", longitude: 24.599914, latitude: 120.998852), PhotoDataModel.init(name: "test3", day: "1", longitude: 24.599914, latitude: 120.998852), PhotoDataModel.init(name: "test4", day: "1", longitude: 24.599914, latitude: 120.998852),PhotoDataModel.init(name: "test5", day: "1", longitude: 24.599914, latitude: 120.998852),  PhotoDataModel.init(name: "test6", day: "1", longitude: 24.599914, latitude: 120.998852), PhotoDataModel.init(name: "test7", day: "1", longitude: 24.599914, latitude: 120.998852), PhotoDataModel.init(name: "test8", day: "1", longitude: 24.545757, latitude: 121.028770), PhotoDataModel.init(name: "test9", day: "1", longitude: 24.545757, latitude: 121.028770), PhotoDataModel.init(name: "test10", day: "1", longitude: 24.545757, latitude: 121.028770), PhotoDataModel.init(name: "test11", day: "2", longitude: 24.584820, latitude: 120.886833), PhotoDataModel.init(name: "test12", day: "2", longitude: 24.584820, latitude: 120.886833), PhotoDataModel.init(name: "test13", day: "2", longitude: 24.584820, latitude: 120.886833), PhotoDataModel.init(name: "test15", day: "2", longitude: 24.584820, latitude: 120.886833), PhotoDataModel.init(name: "test16", day: "3", longitude: 24.388187, latitude: 120.782034), PhotoDataModel.init(name: "test17", day: "3", longitude: 24.388187, latitude: 120.782034), PhotoDataModel.init(name: "test18", day: "3", longitude: 24.388187, latitude: 120.782034), PhotoDataModel.init(name: "test19", day: "3", longitude: 24.388187, latitude: 120.782034), PhotoDataModel.init(name: "test20", day: "3", longitude: 24.388187, latitude: 120.782034),]),
        //        Album(travelName: "南投二日", time: "2017-12-20", day: "2", titleImage: "test10", photos: [PhotoDataModel.init(name: "test1", day: "1", longitude: 23.969050, latitude: 120.960333), PhotoDataModel.init(name: "test2", day: "1", longitude: 23.969050, latitude: 120.960333), PhotoDataModel.init(name: "test3", day: "1", longitude: 23.969050, latitude: 120.960333), PhotoDataModel.init(name: "test4", day: "1", longitude: 23.969050, latitude: 120.960333), PhotoDataModel.init(name: "test5", day: "1", longitude: 23.969050, latitude: 120.960333), PhotoDataModel.init(name: "test6", day: "1", longitude: 23.969050, latitude: 120.960333), PhotoDataModel.init(name: "test7", day: "1", longitude: 23.969050, latitude: 120.960333), PhotoDataModel.init(name: "test8", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test9", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test10", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test11", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test12", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test13", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test14", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test15", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test16", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test17", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test18", day: "2", longitude: 24.055850, latitude: 121.161926),PhotoDataModel.init(name: "test19", day: "2", longitude: 24.055850, latitude: 121.161926), PhotoDataModel.init(name: "test20", day: "2", longitude: 24.055850, latitude: 121.161926),]),
        //        Album(travelName: "苗栗三日", time: "2017-07-14", day: "3", titleImage: "test5", photos: [PhotoDataModel(photoName: ["test1", "test2", "test3", "test4", "test5"], picturesDay: "1", coordinate: CLLocationCoordinate2D(latitude: 24.599914, longitude: 120.998852)), PhotoDataModel(photoName: ["test6", "test7", "test8", "test9", "test10"], picturesDay: "1", coordinate: CLLocationCoordinate2D(latitude: 24.545757, longitude: 121.028770)), PhotoDataModel(photoName: ["test11", "test12", "test13", "test14", "test15"], picturesDay: "2", coordinate: CLLocationCoordinate2D(latitude: 24.584820, longitude: 120.886833)), PhotoDataModel(photoName: ["test16", "test17", "test18", "test19", "test20"], picturesDay: "3", coordinate: CLLocationCoordinate2D(latitude: 24.388187, longitude: 120.782034))]),
        //        Album(travelName: "南投二日", time: "2017-12-20", day: "2", titleImage: "test10", photos: [PhotoDataModel(photoName: ["test11", "test12", "test13", "test14", "test15","test16", "test17", "test18", "test19", "test20"], picturesDay: "1",coordinate: CLLocationCoordinate2D(latitude: 23.969050, longitude: 120.960333)), PhotoDataModel(photoName: ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8", "test9", "test10"], picturesDay: "2", coordinate: CLLocationCoordinate2D(latitude: 24.055850, longitude: 121.161926))])
    ]
}



