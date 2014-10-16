// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


func doSomething<T>(a : T, b :T) {
    println("hello")
}

struct Stack <T> {
    private var items = [T]()
    
    mutating func push(item : T) {
        self.items.append(item)
    }
    
    mutating func pop() -> T {
        var itemToPop = self.items.last
        self.items.removeLast()
        return itemToPop!
    }
}

var myStack = Stack<String>()

myStack.push("Alex")
myStack.push("Stacy")
myStack.pop()
myStack.items


class Node <T> {
    var value: T?
    var next: Node?
}

class LinkedList <T> {
    var head: Node <T>?
    
    func insert(value: T) {
        // 0th case if list is empty
        if head == nil {
            var node = Node<T>()
            node.value = value
            node.next = nil
            head = node
            return
        }
        
        // Otherwise, walk the list
        var currentNode = head
        while currentNode?.next != nil {
            currentNode = currentNode?.next
        }
        
        var node = Node<T>()
        node.value = value
        node.next = nil
        
        currentNode?.next = node
    }
}



var node2 = Node<Int>()
node2.value = 200

node2.next = node1












