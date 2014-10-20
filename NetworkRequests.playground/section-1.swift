import Foundation
import XCPlayground

// allows playground to run async operations
XCPSetExecutionShouldContinueIndefinitely()

let url = NSURL(string: "http://www.codefellows.org")

// setup data task for resource at URL
// makes a GET requests, by default
let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
    if let httpResponse = response as? NSHTTPURLResponse {
        switch httpResponse.statusCode {
            case 200...204:
                for header in httpResponse.allHeaderFields {
                    println(header)
                }
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("responseString: \(responseString)")
            default:
                println("bad response? \(httpResponse.statusCode)")
        }
    }
})

// run the task by calling resume()
dataTask.resume()

let url2 = NSURL(string: "http://www.pdf995.com/samples/pdf.pdf")

// setup second task to download a resource
// allows makes a GET requests, uses temporary file behind the scenes.
let request = NSURLRequest(URL: url2)
let downloadTask = NSURLSession.sharedSession().downloadTaskWithRequest(request, completionHandler: { (url, response, error) -> Void in
    if let httpResponse = response as? NSHTTPURLResponse {
        switch httpResponse.statusCode {
        case 200...204:
            for header in httpResponse.allHeaderFields {
                println(header)
            }
        default:
            println("bad response? \(httpResponse.statusCode)")
        }
    }
})

// run the task by calling resume()
downloadTask.resume()

