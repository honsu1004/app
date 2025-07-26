// Import all the channels to be used by Action Cable
import "./chat_channel"

import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

export default consumer
