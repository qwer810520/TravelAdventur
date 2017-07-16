# TravelAdventur
			
## Demo

### 網路判斷
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/NetworkJudgment.PNG)

* 當無法連接網路時會跳出Alert來提醒使用者。
 
### TouchID
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/TouchID_Demo.gif)

### 首頁相簿呈現(StickyCollectionView-Swift)
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/HomeCollectionView_Demo.gif)

* 使用的第三方： <https://github.com/matbeich/StickyCollectionView-Swift>
* 修改套件裡的一些參數來調整Cell大小。

### QRCode
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/QRCodeDemo.PNG)
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/QRCode_Demo1.gif)

* 利用相簿ID來製作QRCode。
* 讓另一名使用者利用QRcode來讀取ID來加入相簿。

### GoogleMap
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/GoogleMap_Demo.gif)

* 切換CollectionViewCell來更新顯示拍照的地點。

### GooglePlace
![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/GooglePlace_Demo.gif)

* 使用GooglePlace來搜尋拍照地點，確認後在GoogleMap加入新圖標。

### 顯示相片頁面(mosaic-layout)

![](https://github.com/qwer810520/TravelAdventur/blob/master/mini_Demo/DetailCollectionIView_Demo.gif)

* 使用的第三方: <https://github.com/vinnyoodles/mosaic-layout>

## 目前應用功能有
* 以Singleton模式來做撰寫。
* 使用Reachability來做簡單的網路連線判斷。
* Google、Facebook登入、使用TouchID來簡化登入流程。
* 使用SideMenu來顯示使用者相片以及QRCode加入相簿、TouchID開關、登出設置。
* 使用GoogleMap、GooglePlace來記錄此次行程的拍照地點。
* 匯入使用者手機相簿來做新增相片動作。
* 將相簿ID製作成QRcode，讓使用者要分享相簿時只需讓朋友掃瞄QRCode就能加入相簿。
* 以上有關資料存取部分皆以FirebaseAuth、database、storage來做存取。
* 此作品持續更新中.... 
