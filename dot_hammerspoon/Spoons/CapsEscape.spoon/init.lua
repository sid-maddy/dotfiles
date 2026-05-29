--- === CapsEscape ===
---
--- Map Caps Lock to a dual-function key:
---   - Tap  → Escape (with any held modifiers forwarded)
---   - Hold → Control
---
--- Fixes jasonrudolph/ControlEscape.spoon#4: Shift+tap, Cmd+tap, Option+tap
--- now correctly send Shift+Escape, Cmd+Escape, Option+Escape respectively.
---
--- Also cancels Escape on mouse clicks (Ctrl+Click = right-click on macOS)
--- and scroll wheel events (Ctrl+Scroll = zoom).
---
--- **Prerequisite**: Remap Caps Lock → Control in macOS System Settings:
---   System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys →
---   Set Caps Lock key to ⌃ Control
---
--- Usage:
---   hs.loadSpoon('CapsEscape'):start()
---
--- Configurable timeout (set before calling :start()):
---   spoon.CapsEscape.timeout = 0.250
---   spoon.CapsEscape:start()

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'CapsEscape'
obj.version = '1.0'
obj.author = 'Siddhesh Mhadnak'
obj.license = 'MIT - https://opensource.org/licenses/MIT'

--- CapsEscape.timeout
--- Variable
--- Maximum duration (seconds) between key-down and key-up for a press to
--- count as a "tap". Holding longer than this means the key is being used
--- purely as Control. Default: 0.200
obj.timeout = 0.200

function obj:init()
  self.sendEscape = false
  self.lastCtrlPressed = false

  -- Cancel escape if ctrl is held longer than the tap threshold
  self.timer = hs.timer.delayed.new(self.timeout, function() self.sendEscape = false end)

  -- Track ctrl state changes (covers CapsLock remapped to ctrl)
  self.flagsTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    local flags = event:getFlags()
    local ctrlDown = not not flags['ctrl']

    -- Only act when ctrl state actually changes
    if ctrlDown == self.lastCtrlPressed then return false end

    if ctrlDown then
      -- Ctrl just pressed: arm escape, start cancel timer
      self.lastCtrlPressed = true
      self.sendEscape = true
      self.timer:start(self.timeout)
    else
      -- Ctrl just released
      self.lastCtrlPressed = false
      self.timer:stop()

      if self.sendEscape then
        -- Tap detected — forward any other held modifiers with escape
        local mods = {}
        if flags['shift'] then table.insert(mods, 'shift') end
        if flags['cmd'] then table.insert(mods, 'cmd') end
        if flags['alt'] then table.insert(mods, 'alt') end
        hs.eventtap.keyStroke(mods, 'escape', 1)
      end

      self.sendEscape = false
    end

    return false
  end)

  -- Any normal keypress while ctrl is held = used as modifier, cancel escape
  self.keyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
    self.sendEscape = false
    return false
  end)

  -- Mouse clicks and scroll while ctrl is held also cancel escape
  -- (Ctrl+Click = right-click, Ctrl+Scroll = zoom on macOS)
  self.mouseTap = hs.eventtap.new({
    hs.eventtap.event.types.leftMouseDown,
    hs.eventtap.event.types.rightMouseDown,
    hs.eventtap.event.types.scrollWheel,
  }, function(event)
    self.sendEscape = false
    return false
  end)

  return self
end

--- CapsEscape:start()
--- Method
--- Start the Caps Lock → Escape/Control mapping
function obj:start()
  self.flagsTap:start()
  self.keyTap:start()
  self.mouseTap:start()
  return self
end

--- CapsEscape:stop()
--- Method
--- Stop the Caps Lock → Escape/Control mapping
function obj:stop()
  self.flagsTap:stop()
  self.keyTap:stop()
  self.mouseTap:stop()
  self.timer:stop()
  self.sendEscape = false
  self.lastCtrlPressed = false
  return self
end

return obj
