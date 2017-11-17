import Foundation
struct DataProvider: TestObjectDataProvider {
    func getTestObjectList(completion: @escaping ([TestObject]) -> Void) {
        let url = URLMaker.getURL()
        HTTPTransport.getJson(from: url) { json in
            let testObjectList = TestObjectJsonParser.JsonToTestObjectList(json: json)
            completion(testObjectList)
        }
    }
}

struct URLMaker {
    static func getURL() -> URL? {
        let url = URL(string: Keys.rootPath)
        return url
    }
}

struct TestObjectJsonParser {
    
    static func JsonToTestObjectList(json: Any) -> [TestObject] {
        var testObjects = [TestObject]()
        if let curArray = json as? Array<Any> {
            for curItem in curArray {
                if let curData = curItem as? Dictionary<String, Any> {
                    let id = curData[Keys.idKey] as? Int
                    let title = curData[Keys.titleKey] as? String
                    let imgStringUrl = curData[Keys.imgKey] as? String
                    if id != nil &&
                        title != nil &&
                        imgStringUrl != nil {
                        let testObject = TestObject(id: id!, title: title!, imgStringUrl: imgStringUrl!)
                        testObjects.append(testObject)
                    }
                }
            }
        }
        return testObjects
    }
}

struct HTTPTransport {
    static func getJson(from url: URL?, completion: @escaping (Any) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                return
            }
            if data != nil {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
                    completion(json)
                }
            }
        }
        dataTask.resume()
    }
}

struct Keys {
    static let rootPath = "http://private-db05-jsontest111.apiary-mock.com/androids"
    static let idKey = "id"
    static let titleKey = "title"
    static let imgKey = "img"
}
