# TravelAdventur
			
### 功能Demo

### 網路判斷
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/NetworkJudgment1.gif)

* 當無法連接網路時會跳出Alert來提醒使用者。
 
### TouchID
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/TouchID_Demo1.gif)

### 首頁相簿呈現(StickyCollectionView-Swift)
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/HomeCollectionView_Demo1.gif)

* 使用的第三方： <https://github.com/matbeich/StickyCollectionView-Swift>
* 修改套件裡的一些參數來調整Cell大小。

### QRCode
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/QRCodeDemo1.gif)
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/QRCode_Demo1.gif)

* 利用相簿ID來製作QRCode。
* 讓另一名使用者利用QRcode來讀取ID來加入相簿。

### GoogleMap
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/GoogleMap_Demo1.gif)

* 切換CollectionViewCell來更新顯示拍照的地點。

### GooglePlace
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/GooglePlace_Demo1.gif)

* 使用GooglePlace來搜尋拍照地點，確認後在GoogleMap加入新圖標。

### 顯示相片頁面(mosaic-layout)

![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/DetailCollectionIView_Demo1.gif)

* 使用的第三方: <https://github.com/vinnyoodles/mosaic-layout>

## 近期更新
#### 2020更新
* 重構MVC架構為MVP
* 更換[SDWebImage](https://github.com/SDWebImage/SDWebImage)，改採用[Nuke](https://github.com/kean/Nuke)
* 更換[SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)，改使用客製化Indicator
* 更換[TRMosaicLayout](https://github.com/vinnyoodles/mosaic-layout)套件，改採用iOS 13的`UICollectionViewCompositionalLayout`
* 優化UI整體性

#### 2018更新
* 採MVC為架構下去實作。
* UI更新: 所有UI改採用純Code去生成。
* 優化記憶體使用效能以及VC的邏輯處理。
* 資料存部分取改採用FireBase的Cloud Firestore來做存取。

## 應用功能有
* 以Singleton模式來做撰寫。
* ~~使用Reachability來做簡單的網路連線判斷。~~
* Google、Facebook登入、使用TouchID來簡化登入流程。
* ~~使用SideMenu來顯示使用者相片以及QRCode加入相簿、TouchID開關、登出設置。~~
* 使用GoogleMap、GooglePlace來記錄此次行程的拍照地點。
* 匯入使用者手機相簿來做新增相片動作。
* 將相簿ID製作成QRcode，讓使用者要分享相簿時只需讓朋友掃瞄QRCode就能加入相簿。
* 以上有關資料存取部分皆以FirebaseAuth、database、storage來做存取。

 
