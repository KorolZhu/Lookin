# Lookin MCP

This project has a built-in MCP server (`lookin`) that provides iOS UI inspection tools.

When the user asks about view hierarchy, layout, constraints, UI debugging, or anything related to inspecting the connected iOS app, use the `lookin` MCP tools:

- `get_status` — Check connection status
- `get_hierarchy` — Get full view hierarchy
- `search_views` — Search views by class/text/oid
- `get_view` — Get view details by oid
- `get_view_attributes` — Get AutoLayout constraints, properties, event handlers
- `get_screenshot` — Get view screenshot
- `list_viewcontrollers` — List all VCs
- `get_app_info` — Get connected app info
- `reload_hierarchy` — Refresh hierarchy data
- `list_apps` — List connected apps

The MCP server runs on `http://127.0.0.1:47199/mcp` when Lookin app is open.
