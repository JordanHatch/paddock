GROUPS = {
  export_readiness: Group.create!(name: 'Export Readiness'),
  export_clearance: Group.create!(name: 'Export Clearance'),
  export_assurance: Group.create!(name: 'Export Assurance'),
  export_intelligence: Group.create!(name: 'Export Intelligence'),
}

TEAMS = {
  registration_approvals: Team.create!(name: 'Registration and Approvals', group: GROUPS[:export_readiness]),
  export_profile: Team.create!(name: 'Export Profile', group: GROUPS[:export_readiness]),
  nexdoc: Team.create!(name: 'NEXDOC', group: GROUPS[:export_clearance]),
  export_assurance: Team.create!(name: 'Export Assurance', group: GROUPS[:export_assurance]),
  audit: Team.create!(name: 'Audit', group: GROUPS[:export_assurance]),
  export_intelligence: Team.create!(name: 'Export Intelligence', group: GROUPS[:export_intelligence]),
}

SPRINTS = [
  Sprint.create!(name: 'Sprint 1', start_on: Date.parse('2021-06-9'), end_on: Date.parse('2021-06-22')),
  Sprint.create!(name: 'Sprint 2', start_on: Date.parse('2021-06-23'), end_on: Date.parse('2021-07-06')),
  Sprint.create!(name: 'Sprint 3', start_on: Date.parse('2021-07-07'), end_on: Date.parse('2021-07-20')),
  Sprint.create!(name: 'Sprint 4', start_on: Date.parse('2021-07-21'), end_on: Date.parse('2021-08-03')),
]

UPDATES = [
  Update.create!(
    team: TEAMS[:registration_approvals],
    sprint: SPRINTS[0],
    state: 'published',
    content: "This sprint the team are in the final stages of preparation for the private beta. There is still work to be done to finalise the DevOps pipelines for release, but we are confident that these will be resolved before the June 30 milestone.",
    delivery_status: 'green',
    okr_status: 'green',
    current_headcount: 4,
    vacant_roles: 3,
    team_health: 4,
    sprint_goals: [
      'Deploy the application to the production environment',
      'Set up emails for successful applications to CMG',
      'Finalise approvals for go-live',
    ],
    issues_attributes: [
      {
        description: 'Unknowns remain on the access to the Establishments Register to extract data',
        treatment: 'We will work with ISD to resolve this early next week',
        help: 'We need help from a developer who knows how the Establishments Register works',
      }
    ],
    next_sprint_goals: [
      'Release the private beta',
      'Support our participants to use the beta successfully',
      'Plan the roadmap for the next 6 weeks',
    ],
  ),
  Update.create!(
    team: TEAMS[:registration_approvals],
    sprint: SPRINTS[1],
    state: 'published',
    content: "This sprint the team delivered the private beta of Registration and Approvals, which allows an invited exporter to add and remove people from management and control of their establishment.\n\nThis was released to 6 invited exporters, of which 3 have already used the service successfully.",
    delivery_status: 'green',
    okr_status: 'green',
    current_headcount: 4,
    vacant_roles: 3,
    team_health: 5,
    sprint_goals: [
      'Release the private beta',
      'Support our participants to use the beta successfully',
      'Plan the roadmap for the next 6 weeks',
    ],
    next_sprint_goals: [
      'Understand the Establishments Register',
      'Collect feedback from private beta participants',
    ],
  )
]
