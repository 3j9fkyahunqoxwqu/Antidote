// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import AVFoundation

class AudioPlayer {
    enum Sound: String {
        case Calltone = "isotoxin_Calltone"
        case Hangup = "isotoxin_Hangup"
        case Ringtone = "isotoxin_Ringtone"
        case RingtoneWhileCall = "isotoxin_RingtoneWhileCall"
    }

    var playOnlyIfApplicationIsActive = true

    private var players = [Sound: AVAudioPlayer]()

    func playSound(sound: Sound, loop: Bool) {
        if playOnlyIfApplicationIsActive && !UIApplication.isActive {
            return
        }

        guard let player = playerForSound(sound) else {
            return
        }

        player.numberOfLoops = loop ? -1 : 1
        player.currentTime = 0.0
        player.play()
    }

    func isPlayingSound(sound: Sound) -> Bool {
        guard let player = playerForSound(sound) else {
            return false
        }

        return player.playing
    }

    func isPlaying() -> Bool {
        let pl = players.filter {
            $0.1.playing
        }

        return !pl.isEmpty
    }

    func stopSound(sound: Sound) {
        guard let player = playerForSound(sound) else {
            return
        }
        player.stop()
    }

    func stopAll() {
        for (_, player) in players {
            player.stop()
        }
    }
}

private extension AudioPlayer {
    func playerForSound(sound: Sound) -> AVAudioPlayer? {
        if let player = players[sound] {
            return player
        }

        guard let path = NSBundle.mainBundle().pathForResource(sound.rawValue, ofType: "aac") else {
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path)) else {
            return nil
        }

        players[sound] = player
        return player
    }
}
