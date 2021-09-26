# Sprint updates

## Get all sprint updates

This returns all sprints, ordered by their `id`.

```
GET /api/v1/sprint-updates
```

```json
{
  "rel": {
    "prev": null,
    "next": "https://path-to-paddock/api/v1/sprint-updates?page=2"
  },
  "total": 35,
  "results_per_page": 20,
  "current_page": 1,
  "total_pages": 2,
  "results": [
    {
      "id": 1,
      "url": "https://path-to-paddock/sprints/1/export-profile",
      "group": {
        "id": 1,
        "name": "Export Readiness"
      },
      "team": {
        "id": 2,
        "api_url": "https://path-to-paddock/api/v1/teams/2",
        "name": "Export Profile",
        "slug": "export-profile"
      },
      "sprint": {
        "id": 1,
        "api_url": "https://path-to-paddock/api/v1/sprints/1",
        "url": "https://path-to-paddock/sprints/1",
        "name": "Sprint 1",
        "start_on": "2021-07-14",
        "end_on": "2021-07-27"
      },
      "delivery_status": {
        "value": "green",
        "label": "Green"
      },
      "okr_status": {
        "value": "amber",
        "label": "Amber"
      },
      "team_health": {
        "value": "5",
        "label": "5 / 5"
      },
      "headcount": {
        "current_headcount": 8,
        "total_headcount": 8,
        "label": "8 / 8"
      },
      "summary": {
        "markdown": "Sprint overview in **markdown**",
        "html": "<p>Sprint overview in <strong>markdown</strong></p>"
      },
      "sprint_goals": [
        "Sprint goal 1",
        "Sprint goal 2",
        "Sprint goal 3"
      ],
      "next_sprint_goals": [
        "Next sprint goal 1",
        "Next sprint goal 2",
        "Next sprint goal 3"
      ],
      "issues": [
        {
          "id": 1,
          "description": "Issue description",
          "treatment": "Issue treatment",
          "help": "What we need help with",
          "devops_id": "102131"
        }
      ]
    }
  ]
}
```

### Request parameters

* `sprint` - the ID of the [sprint](sprints.md) to filter updates by
* `per_page` - the number of results returned per page (default: `20`)
* `page` - the page of results to request


## Get a single sprint update

Returns the details for the sprint with the requested ID.

```
GET /api/v1/sprint-updates/:id
```

```json
{
  "id": 1,
  "url": "https://path-to-paddock/sprints/1/export-profile",
  "group": {
    "id": 1,
    "name": "Export Readiness"
  },
  "team": {
    "id": 2,
    "api_url": "https://path-to-paddock/api/v1/teams/2",
    "name": "Export Profile",
    "slug": "export-profile"
  },
  "sprint": {
    "id": 1,
    "api_url": "https://path-to-paddock/api/v1/sprints/1",
    "url": "https://path-to-paddock/sprints/1",
    "name": "Sprint 1",
    "start_on": "2021-07-14",
    "end_on": "2021-07-27"
  },
  "delivery_status": {
    "value": "green",
    "label": "Green"
  },
  "okr_status": {
    "value": "amber",
    "label": "Amber"
  },
  "team_health": {
    "value": "5",
    "label": "5 / 5"
  },
  "headcount": {
    "current_headcount": 8,
    "total_headcount": 8,
    "label": "8 / 8"
  },
  "summary": {
    "markdown": "Sprint overview in **markdown**",
    "html": "<p>Sprint overview in <strong>markdown</strong></p>"
  },
  "sprint_goals": [
    "Sprint goal 1",
    "Sprint goal 2",
    "Sprint goal 3"
  ],
  "next_sprint_goals": [
    "Next sprint goal 1",
    "Next sprint goal 2",
    "Next sprint goal 3"
  ],
  "issues": [
    {
      "id": 1,
      "description": "Issue description",
      "treatment": "Issue treatment",
      "help": "What we need help with",
      "devops_id": "102131"
    }
  ]
}
```

