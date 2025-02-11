import { application } from "./application"

import StyleCardController from "./style_card_controller"
application.register("style-card", StyleCardController)

// Import and register other controllers...
import GenerationController from "./generation_controller"
application.register("generation", GenerationController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)
