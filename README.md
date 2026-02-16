# rjsv-websocket

A plugin for `rjsv` that starts a local WebSocket server and allows
external applications to monitor the file transpilation state.

The server sends a notification whenever transpilation finishes,
so other tools can react to changes (e.g. live reload, build automation, etc.).

## Installation

The plugin requires the `em-websocket` Ruby gem
(which automatically installs `eventmachine` as a dependency):

```bash
gem install em-websocket
```

**Recommended installation**: place the plugin in your `$HOME/.rjsv/plugins` directory.

For more details, see the official documentation: [Plugins](https://filipvrba.github.io/ruby-js/#0-plugins)

## Usage

The plugin is enabled by adding the `websocket` argument
to the end of the `rjsv` command.

> It is recommended to place it at the end so that subsequent flags
> are processed by the main application instead of the plugin.

The WebSocket server starts only when file watching (watch mode) is enabled.

### Example

```bash
rjsv -t -w -s 'src/rb' -o 'src/js' websocket
```

## WebSocket Server

After startup, a local WebSocket server runs at:

```txt
ws://localhost:7071
```

### Messages

When transpilation completes, the server sends the following message
to all connected clients:

```json
{ "type": "update" }
```

## Typical Use Cases

- frontend live reload
- build process synchronization
- integration with developer tools

## Architecture Overview

```txt
        ┌───────────────────────┐
        │  RJSV::CLI::States    │
        │  (watch_state)        │
        └─────────┬─────────────┘
                  │ tracks files
                  ▼
        ┌───────────────────────┐
        │  File System Events   │
        │  (added, modified,    │
        │   removed)            │
        └─────────┬─────────────┘
                  │ trigger
                  ▼
        ┌─────────────────────────────┐
        │ RJSV::Plugins::Websocket    │
        │           States            │
        │ (create_server, send_update)│
        └─────────┬───────────┬───────┘
                  │           │
                  │ send      │ server lifecycle
                  ▼           ▼
        ┌─────────────────────────────┐
        │  WebSocket Server           │
        │  (ws://localhost:7071)      │
        └─────────────────────────────┘
                  │
                  │ notification "update"
                  ▼
        ┌─────────────────────────────┐
        │ Connected Clients / Tools   │
        │ (live reload, build sync)   │
        └─────────────────────────────┘
```

This diagram shows how the CLI, WebSocket plugin, server, and connected clients interact.
