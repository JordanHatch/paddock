# API authentication

Paddock follows the OAuth 2.0 standard to authenticate API requests.

At present, API clients use the [Client Credentials grant type][client-credentials] to request resources. This means that requests are made on behalf of your API client, rather than on behalf of a specific Paddock user.


## Before you start

You will need:

* an OAuth 2.0 application created in Paddock
* your `client_id` and `client_secret`


## Request an access token

Make the following request to the Paddock API to request an OAuth 2.0 access token:

```
POST /oauth/token

grant_type=client_credentials&
  client_id=<client_id>&
  client_secret=<client_secret>
```

This returns a JSON object containing your access token:

```json
{
  "access_token": "<your access token>",
  "token_type": "Bearer",
  "expires_in": 7200,
  "scope": "read",
  "created_at": 1234567890
}
```

OAuth 2.0 access tokens are short-lived and will expire in the time period specified in the API request. You'll need to request a new access token on a regular basis.


[client-credentials]: https://www.oauth.com/oauth2-servers/access-tokens/client-credentials/
