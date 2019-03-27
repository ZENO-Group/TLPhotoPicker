//
//  SynchronizedDictionary.swift
//  Pods-TLPhotoPicker_Example
//
//  Created by wade.hawk on 28/03/2019.
//

import Foundation

public class SynchronizedDictionary<K:Hashable,V> {
    private var dictionary: [K:V] = [:]
    private let accessQueue = DispatchQueue(label: "SynchronizedDictionaryAccess",
                                            attributes: .concurrent)
    
    deinit {
//        print("deinit SynchronizedDictionary")
    }
    
    public func removeAll() {
        self.accessQueue.async(flags:.barrier) {
            self.dictionary.removeAll()
        }
    }
    
    public func removeValue(forKey: K) {
        self.accessQueue.async(flags:.barrier) {
            self.dictionary.removeValue(forKey: forKey)
        }
    }
    
    public func forEach(_ closure: ((V) -> Void)) {
        self.accessQueue.sync {
            self.dictionary.forEach{ (_,value) in
                closure(value)
            }
        }
    }
    
    public subscript(key: K) -> V? {
        set {
            self.accessQueue.async(flags:.barrier) {
                self.dictionary[key] = newValue
            }
        }
        get {
            var element: V?
            self.accessQueue.sync {
                element = self.dictionary[key]
            }
            return element
        }
    }
}
