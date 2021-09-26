# Sprints

## Get all sprints

This returns all sprints, ordered by their `id`.

```
GET /api/v1/sprints
```

```json
{
  "rel": {
    "prev": null,
    "next": null
  },
  "total": 3,
  "results_per_page": 20,
  "current_page": 1,
  "total_pages": 1,
  "results": [
    {
      "id": 1,
      "url": "https://path-to-paddock/sprints/1",
      "name": "Sprint 1",
      "start_on": "2021-07-14",
      "end_on": "2021-07-27"
    },
    {
      "id": 2,
      "url": "https://path-to-paddock/sprints/2",
      "name": "Sprint 2",
      "start_on": "2021-07-28",
      "end_on": "2021-08-10"
    },
    {
      "id": 3,
      "url": "https://path-to-paddock/sprints/3",
      "name": "Sprint 3",
      "start_on": "2021-08-11",
      "end_on": "2021-08-24"
    }
  ]
}
```

### Request parameters

* `per_page` - the number of results returned per page (default: `20`)
* `page` - the page of results to request


## Get a single sprint

Returns the details for the sprint with the requested ID.

```
GET /api/v1/sprints/:id
```

```json
{
  "id": 1,
  "url": "https://path-to-paddock/sprints/1",
  "name": "Sprint 1",
  "start_on": "2021-07-14",
  "end_on": "2021-07-27"
}
```

