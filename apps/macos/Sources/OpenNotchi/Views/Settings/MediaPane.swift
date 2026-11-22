import SwiftUI

struct MediaPane: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var media: MediaManager

    var body: some View {
        Form {
            Section("Playback & Style") {
                Picker("Artwork Style", selection: $settings.artworkStyle) {
                    ForEach(PlayerArtworkStyle.allCases) { style in
                        Label(style.displayName, systemImage: style.icon).tag(style)
                    }
                }
                Toggle("Ambient artwork aura glow", isOn: $settings.ambientAuraEnabled)
                Toggle("Show lyrics on home player", isOn: $settings.lyricsOnHome)
            }
            Section("Apps") {
                Toggle("Apple Music", isOn: $settings.appleMusicEnabled)
                Toggle("Spotify", isOn: $settings.spotifyEnabled)
            }
            Section("Spotify on other devices") {
                SpotifyConnectSettings()
            }
            Section("YouTube in your browser") {
                Toggle("YouTube and YouTube Music", isOn: $settings.youtubeEnabled)
                Toggle("Firefox (macOS media controls)", isOn: $settings.firefoxEnabled)
                if !media.browsersNeedingJavaScript.isEmpty {
                    Label(
                        "\(media.browsersNeedingJavaScript.joined(separator: ", ")) needs “Allow JavaScript from Apple Events” turned on.",
                        systemImage: "exclamationmark.triangle.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.orange)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Firefox uses macOS media controls; no JavaScript from Apple Events setting is needed. YouTube and YouTube Music playback in Firefox will appear here when Firefox publishes it to Control Center.")
                    Text("Next and Previous in Firefox use YouTube keyboard shortcuts and need Accessibility access for OpenNotchi. macOS will ask when you first use them.")
                    Text("Chrome, Brave, Edge, Arc and Safari need JavaScript from Apple Events turned on once:")
                    Text("• Chrome, Brave, Edge, Arc: View → Developer → Allow JavaScript from Apple Events")
                    Text(
                        "• Safari: Settings → Advanced → Show features for web developers, then Develop → Allow JavaScript from Apple Events"
                    )
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Section {
                Text(
                    "macOS asks for permission to control each app the first time it's used. You can change this in System Settings → Privacy & Security → Automation."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
}
