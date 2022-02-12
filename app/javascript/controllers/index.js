// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import BackgroundRefreshController from "./background_refresh_controller.js"
application.register("background-refresh", BackgroundRefreshController)

import FilterableListController from "./filterable_list_controller.js"
application.register("filterable-list", FilterableListController)

import ModalWindowController from "./modal_window_controller.js"
application.register("modal-window", ModalWindowController)

import MultipleSelectController from "./multiple_select_controller.js"
application.register("multiple-select", MultipleSelectController)

import RedeemInvitationController from "./redeem_invitation_controller.js"
application.register("redeem-invitation", RedeemInvitationController)

import SortableCommitmentsListController from "./sortable_commitments_list_controller.js"
application.register("sortable-commitments-list", SortableCommitmentsListController)

import TurboFormRedirectController from "./turbo_form_redirect_controller.js"
application.register("turbo-form-redirect", TurboFormRedirectController)

import UpdateIssuesController from "./update_issues_controller.js"
application.register("update-issues", UpdateIssuesController)

import UpdateSingleIssueController from "./update_single_issue_controller.js"
application.register("update-single-issue", UpdateSingleIssueController)
