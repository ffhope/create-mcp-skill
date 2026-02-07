# Create MCP Skill

A skill that guides you through creating standard MCP (Model Context Protocol) server projects for Cursor and other AI agents.

## Installation

```bash
npx skills add ffhope/create-mcp-skill@create-mcp
```

## What This Skill Does

This skill provides step-by-step instructions for creating MCP servers, including:

- Creating standard MCP server project structure
- Developing MCP tools (Tools) and resources (Resources)
- Configuring Cursor MCP connections
- Testing and debugging MCP servers
- Understanding MCP architecture and best practices

## Use When

Use this skill when:

- Creating new MCP server projects
- Adding MCP tools (functions AI can call)
- Adding MCP resources (data AI can read)
- Configuring Cursor MCP connections
- Debugging MCP server issues
- Understanding MCP protocol and architecture

## Features

- **Project Templates**: Generate complete MCP server projects with one command
- **Tool Development**: Step-by-step guide for creating MCP tools
- **Resource Development**: Instructions for adding MCP resources
- **Cursor Integration**: Complete Cursor configuration guide
- **Validation Scripts**: Automated project structure validation
- **Testing Tools**: Scripts for testing MCP servers
- **Best Practices**: MCP architecture patterns and guidelines

## Quick Start

1. Install the skill: `npx skills add ffhope/create-mcp-skill@create-mcp`
2. Generate a new MCP project: `./scripts/generate-mcp.sh my-mcp-server`
3. Configure Cursor: Follow instructions in `reference.md`
4. Test your server: `./scripts/test-mcp.sh index.js`

## Requirements

- Node.js 18 or higher
- Cursor IDE (or other MCP-compatible agent)
- GitHub account (for publishing)

## Resources

- [Skills Directory](https://skills.sh/)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Skills CLI](https://skills.sh/docs/cli)

## License

MIT
