#!/usr/bin/env bash

### START-OF-ICON-MAP
function icon_map() {
	case "$1" in
	"Alacritty")
		icon_result=":alacritty:"
		;;
	"Anki")
		icon_result=":anki:"
		;;
	"App Store")
		icon_result=":app_store:"
		;;
	"Arc")
		icon_result=":arc:"
		;;
	"Bitwarden")
		icon_result=":bit_warden:"
		;;
	"Blender")
		icon_result=":blender:"
		;;
	"Calibre")
		icon_result=":book:"
		;;
	"Calculator")
		icon_result=":calculator:"
		;;
	"Calendar" | "Notion Calendar")
		icon_result=":calendar:"
		;;
	"Amazon Chime")
		icon_result=":chime:"
		;;
	"Citrix Workspace" | "Citrix Viewer")
		icon_result=":citrix:"
		;;
	"Claude")
		icon_result=":claude:"
		;;
	"Code" | "Code - Insiders")
		icon_result=":code:"
		;;
	"Cursor")
		icon_result=":cursor:"
		;;
	"DataGrip")
		icon_result=":datagrip:"
		;;
	"DataSpell")
		icon_result=":dataspell:"
		;;
	"Default")
		icon_result=":default:"
		;;
	"Discord" | "Discord Canary" | "Discord PTB")
		icon_result=":discord:"
		;;
	"Docker" | "Docker Desktop")
		icon_result=":docker:"
		;;
	"Dropbox")
		icon_result=":dropbox:"
		;;
	"Element")
		icon_result=":element:"
		;;
	"Emacs")
		icon_result=":emacs:"
		;;
	"FaceTime")
		icon_result=":face_time:"
		;;
	"Figma")
		icon_result=":figma:"
		;;
	"Finder")
		icon_result=":finder:"
		;;
	"Firefox")
		icon_result=":firefox:"
		;;
	"Firefox Developer Edition" | "Firefox Nightly")
		icon_result=":firefox_developer_edition:"
		;;
	"System Preferences" | "System Settings")
		icon_result=":gear:"
		;;
	"Ghostty")
		icon_result=":ghostty:"
		;;
	"Godot")
		icon_result=":godot:"
		;;
	"GoLand")
		icon_result=":goland:"
		;;
	"Chromium" | "Google Chrome" | "Google Chrome Canary")
		icon_result=":google_chrome:"
		;;
	"Home Assistant")
		icon_result=":home_assistant:"
		;;
	"IntelliJ IDEA")
		icon_result=":idea:"
		;;
	"Inkscape")
		icon_result=":inkscape:"
		;;
	"Insomnia")
		icon_result=":insomnia:"
		;;
	"iTerm" | "iTerm2")
		icon_result=":iterm:"
		;;
	"Jellyfin Media Player")
		icon_result=":jellyfin:"
		;;
	"Joplin")
		icon_result=":joplin:"
		;;
	"KeePassXC")
		icon_result=":kee_pass_x_c:"
		;;
	"Keynote")
		icon_result=":keynote:"
		;;
	"LINE")
		icon_result=":line:"
		;;
	"Linear")
		icon_result=":linear:"
		;;
	"LM Studio")
		icon_result=":lm_studio:"
		;;
	"LocalSend")
		icon_result=":localsend:"
		;;
	"Maps" | "Google Maps")
		icon_result=":maps:"
		;;
	"Mattermost")
		icon_result=":mattermost:"
		;;
	"Messages")
		icon_result=":messages:"
		;;
	"Messenger")
		icon_result=":messenger:"
		;;
	"Microsoft Excel")
		icon_result=":microsoft_excel:"
		;;
	"Microsoft Outlook")
		icon_result=":microsoft_outlook:"
		;;
	"Microsoft PowerPoint")
		icon_result=":microsoft_power_point:"
		;;
	"Microsoft Remote Desktop")
		icon_result=":microsoft_remote_desktop:"
		;;
	"Microsoft Teams" | "Microsoft Teams (work or school)")
		icon_result=":microsoft_teams:"
		;;
	"Microsoft Word")
		icon_result=":microsoft_word:"
		;;
	"Miro")
		icon_result=":miro:"
		;;
	"MongoDB Compass"*)
		icon_result=":mongodb:"
		;;
	"mpv")
		icon_result=":mpv:"
		;;
	"Music")
		icon_result=":music:"
		;;
	"Neovim" | "neovim" | "nvim" | "vi")
		icon_result=":neovim:"
		;;
	"Notes")
		icon_result=":notes:"
		;;
	"Notion")
		icon_result=":notion:"
		;;
	"Numbers")
		icon_result=":numbers:"
		;;
	"Obsidian")
		icon_result=":obsidian:"
		;;
	"OBS")
		icon_result=":obsstudio:"
		;;
	"ChatGPT")
		icon_result=":openai:"
		;;
	"OpenVPN Connect")
		icon_result=":openvpn_connect:"
		;;
	"Pages")
		icon_result=":pages:"
		;;
	"Parallels Desktop")
		icon_result=":parallels:"
		;;
	"Parsec")
		icon_result=":parsec:"
		;;
	"Preview" | "Skim" | "zathura")
		icon_result=":pdf:"
		;;
	"Pi-hole Remote")
		icon_result=":pihole:"
		;;
	"Podcasts")
		icon_result=":podcasts:"
		;;
	"Postman")
		icon_result=":postman:"
		;;
	"Proton Mail" | "Proton Mail Bridge")
		icon_result=":proton_mail:"
		;;
	"PyCharm")
		icon_result=":pycharm:"
		;;
	"Reminders")
		icon_result=":reminders:"
		;;
	"Safari" | "Safari Technology Preview")
		icon_result=":safari:"
		;;
	"Sequel Ace")
		icon_result=":sequel_ace:"
		;;
	"Sequel Pro")
		icon_result=":sequel_pro:"
		;;
	"SF Symbols")
		icon_result=":sf_symbols:"
		;;
	"Signal")
		icon_result=":signal:"
		;;
	"Sketch")
		icon_result=":sketch:"
		;;
	"Slack")
		icon_result=":slack:"
		;;
	"Spotify")
		icon_result=":spotify:"
		;;
	"Spotlight")
		icon_result=":spotlight:"
		;;
	"Sublime Text")
		icon_result=":sublime_text:"
		;;
	"Telegram")
		icon_result=":telegram:"
		;;
	"Terminal")
		icon_result=":terminal:"
		;;
	"Microsoft To Do" | "Things")
		icon_result=":things:"
		;;
	"Thunderbird" | "Thunderbird Daily")
		icon_result=":thunderbird:"
		;;
	"Todoist")
		icon_result=":todoist:"
		;;
	"Tor Browser")
		icon_result=":tor_browser:"
		;;
	"UTM")
		icon_result=":utm:"
		;;
	"MacVim" | "Vim" | "VimR")
		icon_result=":vim:"
		;;
	"VLC")
		icon_result=":vlc:"
		;;
	"VMware Fusion")
		icon_result=":vmware_fusion:"
		;;
	"VSCodium")
		icon_result=":vscodium:"
		;;
	"WebStorm")
		icon_result=":web_storm:"
		;;
	"WezTerm")
		icon_result=":wezterm:"
		;;
	"WhatsApp" | "‎WhatsApp")
		icon_result=":whats_app:"
		;;
	"Xcode")
		icon_result=":xcode:"
		;;
	"Zed")
		icon_result=":zed:"
		;;
	"Zen")
		icon_result=":zen_browser:"
		;;
	"zoom.us")
		icon_result=":zoom:"
		;;
	"Zulip")
		icon_result=":zulip:"
		;;
	*)
		icon_result=":default:"
		;;
	esac
}
### END-OF-ICON-MAP

icon_map "$1"
echo "$icon_result"
