# Teams

## Get all teams

This returns all teams, ordered by their `id`.

```
GET /api/v1/teams
```

```json
{
  "rel": {
    "prev": null,
    "next": "https://path-to-paddock/api/v1/teams?page=2"
  },
  "total": 3,
  "results_per_page": 2,
  "current_page": 1,
  "total_pages": 2,
  "results": [
    {
      "id": 1,
      "slug": "registration-and-approvals",
      "name": "Registration and Approvals",
      "start_on": "2021-04-01",
      "group": {
        "id": 1,
        "name": "Export Readiness"
      }
    },
    {
      "id": 2,
      "slug": "export-profile",
      "name": "Export Profile",
      "start_on": null,
      "group": {
        "id": 1,
        "name": "Export Readiness"
      }
    }
  ]
}
```

### Request parameters

* `per_page` - the number of results returned per page (default: `20`)
* `page` - the page of results to request


## Get a single team

Returns the details for the team with the requested ID.

```
GET /api/v1/teams/:id
```

```json
{
  "id": 1,
  "slug": "registration-and-approvals",
  "name": "Registration and Approvals",
  "start_on": "2021-04-01",
  "group": {
    "id": 1,
    "name": "Export Readiness"
  }
}
```

