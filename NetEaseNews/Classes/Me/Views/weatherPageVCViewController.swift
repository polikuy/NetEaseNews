//
//  weatherPageVCViewController.swift
//  毕业设计
//
//  Created by 李宇佳 on 16/6/11.
//  Copyright © 2016年 lyj. All rights reserved.
//

import UIKit

class weatherPageVCViewController: UIViewController {

    @IBOutlet var weatherSummaryL: UILabel!
    @IBOutlet var maxImage: UIImageView!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var cityL: UILabel!
    
    var searchBarText: String!
    var str_weatherSummary:String!
    
    var max_marr :Array<String> = []
    var min_marr :Array<String> = []
    var maxTemp_arr : Array<String> = []
    var minTemp_arr : Array<String> = []
    var arr_MinTemp :Array<String> = []
    var arr_MaxTemp :Array<String> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weather("Beijing")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:天气函数
    func weather(searchBarText:String) -> Void {
        var tempCity = searchBarText
        
        if searchBarText == "Qingdao" || searchBarText == "qingdao" {
            
            tempCity = "Tsingtao"
        } else if tempCity.containsString("y") {
            
            tempCity = tempCity.stringByReplacingOccurrencesOfString("y", withString: "Y")
        }

        let str = "http://www.weather-forecast.com/locations/\(tempCity)/forecasts/latest"
        
        //创建url
        let urlStr = str
        let url = NSURL(string: urlStr)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!){ (data, response, error) in
            
            if data != nil{
                
                let str = String(data: data!, encoding: NSUTF8StringEncoding)
                
                //截取字符串 获取weather summary
                var array = str?.componentsSeparatedByString("</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if array?.count < 2 {
                    
                    self.tip("输入城市名字有误，请重新输入")
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                    self.cityL.text = "城市：\(tempCity)"
                    let strSummary = array![1]
                    let arraySummary = strSummary.componentsSeparatedByString("</span>")
                    self.str_weatherSummary = arraySummary[0]
                    if (self.str_weatherSummary.rangeOfString("&deg;C") != nil) {
                        
                        self.str_weatherSummary = self.str_weatherSummary.stringByReplacingOccurrencesOfString("&deg;C", withString: "°C")
                        self.weatherSummaryL.text! = self.str_weatherSummary!
                    }
                    //获取最高温度最低温度
                    self.temperature(str!)
                    })
                }
            }
        }
        task.resume()
    }
    
    //MARK:最高温度与最低温度
    func temperature(str:String) -> Void {
        
        let array3 = str.componentsSeparatedByString("Max.&nbsp;Temp<span class=\"not_in_print\"><br /></span>(<span class=\"tempu\">C</span>)</div></th>")
        var str_tempM = array3[1]
        
        for var index in 0...5{
            
            index += 1
            str_tempM = str_tempM.stringByReplacingOccurrencesOfString("<td class=\"num_cell dark temp-color\(index)\">", withString: "A")
            str_tempM = str_tempM.stringByReplacingOccurrencesOfString("</span></td>", withString: "A")
        }
        
        //设置最高温度
        str_tempM = str_tempM.stringByReplacingOccurrencesOfString("A<span class=\"temp\">", withString: "A")
        arr_MaxTemp = str_tempM.componentsSeparatedByString("</tr>")
        let str_MaxTemp = arr_MaxTemp[0]
        arr_MaxTemp = str_MaxTemp.componentsSeparatedByString("A")
        
        //设置最低温度
        arr_MinTemp = str_tempM.componentsSeparatedByString("Min.&nbsp;Temp<span class=\"not_in_print\"><br /></span>(<span class=\"tempu\">C</span>)</div></th>")
        var str_tempMin = arr_MinTemp[1]
        arr_MinTemp = str_tempMin.componentsSeparatedByString("</tr>")
        str_tempMin = arr_MinTemp[0]
        arr_MinTemp = str_tempMin.componentsSeparatedByString("A")
        maxTemp.text = "最高温度：\(arr_MaxTemp[1])°C 最低温度：\(arr_MinTemp[1])°C"
        
        let maxImageStr = Int (arr_MaxTemp[1])
        let minImageStr = Int (arr_MinTemp[1])
        
        //设置图片
        if  maxImageStr >= 30 && minImageStr > 20{
            maxImage.image = UIImage.init(named: "temperature-weather-ic_128")
        } else if maxImageStr < 30 && maxImageStr >= 10{
            maxImage.image = UIImage.init(named: "sun-smile-glasses-icon_128")
        } else {
            maxImage.image = UIImage.init(named: "snow-snowflakes-icon_128")
        }
        
        //MARK:利用遍历取出所有低温
        for var num = 1; num < arr_MinTemp.count; num += 2 {
            min_marr.append(arr_MinTemp[num])
        }
        //        print("-----minTemp:\(min_marr)-----")
        
        //MARK:利用遍历取出所有高温
        for var num = 1; num < arr_MaxTemp.count; num += 2 {
            
            max_marr.append(arr_MaxTemp[num])
            
        }
        //        maxTemp_arr = max_marr
        //        minTemp_arr = min_marr
        maxTemp_arr = max_marr
        minTemp_arr = min_marr
        
    }
    
    //MARK:搜索信息提示消息
    func tip(strTip:String) -> Void {
        
        let alertC = UIAlertController.init(title: "提示", message: strTip, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
        alertC.addAction(alertAction)
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertC, animated: true, completion: nil)
        }
        
    }

    
    @IBAction func searchBtn(sender: AnyObject) {
    
        //设置searchBar出现空的提示
        if searchBar.text!.isEmpty {
            
            let tipStr = "请正确输入城市名"
            tip(tipStr)
            
        } else if ((searchBar.text?.rangeOfString(" ")) != nil ){
            
            self.searchBarText = searchBar.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
            weather(searchBarText)
            
        } else {
            //调用函数
            self.searchBarText = searchBar.text
            self.weather(self.searchBarText)
            
        }

    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
