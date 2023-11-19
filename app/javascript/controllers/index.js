// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"
import MessagesController from "./messages_controller";
import UsersSearchController from "./users_search_controller";
// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

application.register("messages", MessagesController)
application.register("users_search", UsersSearchController)
// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
