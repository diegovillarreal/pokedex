//
//  Pokemon.swift
//  PokeDex
//
//  Created by Admin on 6/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _desc: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _evoText: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexId
    }
    
    var desc: String {
        if _desc == nil  {
            _desc = ""
        }
        return _desc
    }
    
    var type: String {
        if _type == nil  {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil  {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil  {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil  {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil  {
            _attack = ""
        }
        return _attack
    }
    
    var evoText: String {
        if _evoText == nil  {
            _evoText = ""
        }
        return _evoText
    }
    
    var nextEvoID: String {
        if _nextEvoId == nil  {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLevel: String {
        if _nextEvoLevel == nil  {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in let result = response.result

            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in let descResult = response.result
                            
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] {
                                    self._desc = "\(description)"
                                    print(self._desc)
                                }
                                
                            }
                            completed()
                        }
                    }
                } else {
                    self._desc = ""
                }
                
                
                if let evoArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evoArr.count > 0 {
                    if let to = evoArr[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evoArr[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvoId = num
                                self._evoText = to
                                
                                if let lvl = evoArr[0]["level"] as? Int {
                                    self._nextEvoLevel = "\(lvl)"
                                    print(self._nextEvoLevel)
                                }
                                
                                print(self._nextEvoId)
                                print(self._evoText)

                                
                            }
                        }
                    }
                    
                }

            }
            
        }
    }
    
}