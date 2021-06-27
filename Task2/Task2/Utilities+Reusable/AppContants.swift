//
//  AppContants.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation


/// An enum for app urls, there can be many wasy to do such things like creating an Config file, which is do in generat but i chose to use this as its just an assignemnt and conif file is not required.
enum AppURL: String {
    case base = "https://pokeapi.co/api/v2"
    case imageDownload = "https://img.pokemondb.net/sprites/x-y/normal/"
}

enum APIKey: String {
    case limit = "limit"
}

enum APIEndPoints: String {
    case pokemon = "/pokemon"
}
