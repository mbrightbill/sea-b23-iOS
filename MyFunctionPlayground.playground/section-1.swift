// Playground - noun: a place where people can play

import UIKit

//this is just our regular function, takes in two strings, returns them combined
func combineTwoStrings(a : String, b : String) -> String {
    return a + b
}
//calling the function
combineTwoStrings("Brad", "Johnson")

//create a variable to store the function
var combineTwoStringsFunction : (String,String) -> String = combineTwoStrings

//create a function that takes in a function as a parameter
func doSomethingWithTwoStrings(a : String, b : String, doSomething : (String, String) -> String) -> String {
    return doSomething("Russell","Wilson")
}

//doSomethingWithTwoStrings("Brad", "Johnson", combineTwoStringsFunction)


doSomethingWithTwoStrings("Brad", "Johnson") {
    $0 + $1
}






