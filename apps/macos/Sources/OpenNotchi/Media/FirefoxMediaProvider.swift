import AppKit

/// Reads Firefox's macOS media session. Firefox does not support injecting
/// JavaScript through Apple Events, so this uses the local media-control helper.
final class FirefoxMediaProvider: MediaProvider {
    let id = "org.mozilla.firefox"
    let displayName = "Firefox"
    let notificationName: String? = nil
    var showsInLauncher: Bool { false }

    private var helper: URL? {
        ["/opt/homebrew/bin/media-control", "/usr/local/bin/media-control"]
            .first(where: FileManager.default.isExecutableFile(atPath:))
            .map { URL(fileURLWithPath: $0) }
    }

    private struct Session: Decodable {
        let bundleIdentifier: String?
        let title: String?
        let artist: String?
        let album: String?
        let duration: Double?
        let elapsedTime: Double?
        let playing: Bool?
        let artworkData: String?
    }

    private func call(_ arguments: [String]) -> Data? {
        guard let helper else { return nil }
        let process = Process()
        process.executableURL = helper
        process.arguments = arguments
        let output = Pipe()
        process.standardOutput = output
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
            let data = output.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            return process.terminationStatus == 0 ? data : nil
        } catch { return nil }
    }

    private func session(artwork: Bool) -> Session? {
        let args = ["get", "--bundle-id=org.mozilla.firefox"] + (artwork ? [] : ["--no-artwork"])
        guard let data = call(args), let sessions = try? JSONDecoder().decode([Session].self, from: data) else { return nil }
        return sessions.first { $0.bundleIdentifier == id && !($0.title ?? "").isEmpty }
    }

    func fetch() -> NowPlayingInfo? {
        guard isRunning, let state = session(artwork: false), let title = state.title else { return nil }
        return NowPlayingInfo(
            title: title,
            artist: state.artist ?? "",
            album: state.album?.isEmpty == false ? state.album! : "Firefox",
            duration: state.duration ?? 0,
            position: state.elapsedTime ?? 0,
            isPlaying: state.playing ?? false,
            sourceID: id
        )
    }

    func fetchArtwork() -> NSImage? {
        guard let encoded = session(artwork: true)?.artworkData,
              let data = Data(base64Encoded: encoded) else { return nil }
        return NSImage(data: data)
    }

    private func command(_ name: String, _ value: String? = nil) {
        _ = call([name] + (value.map { [$0] } ?? []))
    }
    func playPause() { command("toggle-play-pause") }
    func nextTrack() { command("next-track") }
    func previousTrack() { command("previous-track") }
    func seek(to seconds: Double) { command("seek", String(seconds)) }
}
