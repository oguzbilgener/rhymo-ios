//
//  RhymoSocket.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import SwiftyJSON
import Starscream

class RhymoSocket: NSObject, WebSocketDelegate {

  var socket: WebSocket?
  var delegate: RhymoSocketDelegate?
  
  var userId: Int
  var venueId: Int
  
  init(userId: Int, venueId: Int) {
    self.userId = userId
    self.venueId = venueId
    super.init()
    println("init rhymosocket")
    socket = WebSocket(url: NSURL(scheme: "ws", host: RhymoClient.retrievePreferredHostname(), path: "/v1/socket/client")!)
    socket?.delegate = self
  }
  
  func connect() {
    println("connect requested")
    socket?.connect()
  }
  
  func disconnect() {
    println("disconnect requested")
    socket?.disconnect()
  }
  
  func websocketDidConnect(socket: WebSocket) {
    println("websocket is connected")
    
    handshake()
    if let socketDelegate = delegate {
      socketDelegate.socketConnected()
    }
  }
  
  func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    println("websocket is disconnected: \(error?.localizedDescription)")
    if let socketDelegate = delegate {
      socketDelegate.socketDisconnected()
    }
  }
  
  func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    if let data = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
      let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
      let label = json["label"].stringValue
      let obj = json["object"]
      println(label)
      
      if(label == "shakeBack") {
        openVenue()
      }
      else if(label == "request_playlist") {
        let playlist = parsePlaylist(obj)
        delegate?.requestPlaylistUpdated(parsePlaylist(obj))
      }
      else if(label == "history_playlist") {
        let playlist = parsePlaylist(obj)
        delegate?.historyPlaylistUpdated(playlist)
      }
      else if(label == "auto_playlist") {
        let playlist = parsePlaylist(obj)
        delegate?.autoPlaylistUpdated(playlist)
      }
      else if(label == "startSong") {
        var nowPlayingIndex:Int? = nil
        if let index = obj["currentAutoIndex"].int {
          nowPlayingIndex = index
        }
        let t = RhymoClient.parsePlaylistTrack(obj)
        delegate?.nowPlayingUpdated(t, currentAutoIndex: nowPlayingIndex)
      }
      else if(label == "noSong") {
        delegate?.nowPlayingUpdated(PlaylistTrack(), currentAutoIndex: nil)
      }
      else {
        println("got some gibberish: \(text)")
      }
    }
  }
  
  func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    println("got some data: \(data.length)")
  }
  
  func handshake() {
    let handshakeMessage:JSON = ["label": "handShake", "user_id": self.userId]
    if let jsonString = jsonAsString(handshakeMessage) {
      socket?.writeString(jsonString)
    }
  }
  
  func openVenue() {
    var openMessage:JSON = ["label": "openVenue", "venue_id": self.venueId]
    if let jsonString = jsonAsString(openMessage) {
      socket?.writeString(jsonString)
    }
  }
  
  func parsePlaylist(json: JSON) -> [PlaylistTrack] {
    var playlist = [PlaylistTrack]()
    for (index: String, values: JSON) in json {
      var track = RhymoClient.parsePlaylistTrack(values)
      playlist.append(track)
    }
    return playlist
  }
  
  private func buildMessage(#label: String, obj: JSON) -> JSON {
    var params: JSON = ["label": label]
    params["object"] = obj
    return params
  }
  
  private func jsonAsString(json: JSON) -> String? {
    return json.rawString(encoding: NSUTF8StringEncoding, options: NSJSONWritingOptions.allZeros)
  }
}

protocol RhymoSocketDelegate: class {
  func socketConnected()
  func socketDisconnected()
  func historyPlaylistUpdated(playlist: [PlaylistTrack])
  func requestPlaylistUpdated(playlist: [PlaylistTrack])
  func autoPlaylistUpdated(playlist: [PlaylistTrack])
  func nowPlayingUpdated(track: PlaylistTrack?, currentAutoIndex: Int?)
}