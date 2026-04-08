# Graph API

REST API request files for Microsoft Graph, organized by service area. These files can be used with tools such as [REST Client for VS Code](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) or imported into API clients like Postman.

## Files

### Top-Level

| File | Description |
|------|-------------|
| [GraphExplorerURL.rest](./GraphExplorerURL.rest) | Sample Graph API requests demonstrating common query patterns. Use as a reference or starting point for Graph Explorer sessions. |

### Security API

| File | Description |
|------|-------------|
| [Get-DLPAlerts.rest](./Security%20API/Get-DLPAlerts.rest) | Graph API requests for querying Data Loss Prevention (DLP) alerts via the Microsoft Graph Security API. |

---

## Usage

These `.rest` files can be opened directly in VS Code with the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client), which allows you to send requests and view responses without leaving the editor.

For authentication, you will need a valid Microsoft Graph access token with the appropriate permissions for each request. Refer to the [Microsoft Graph documentation](https://learn.microsoft.com/en-us/graph/overview) for permission requirements.
